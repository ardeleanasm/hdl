
module MAC where


import Clash.Prelude


import Clash.Explicit.Testbench


ma :: Num a=>a->(a,a)->a
ma acc (x,y) = acc + x * y

macT :: Num a => a -> (a,a) -> (a,a)
macT acc (x,y) = (accumulate,o)
    where
        accumulate = ma acc (x,y)
        o = acc

topEntity
    :: Clock System
    -> Reset System
    -> Enable System
    -> Signal System (Signed 8, Signed 8)
    -> Signal System (Signed 8)
topEntity = exposeClockResetEnable $ mealy macT 0
{-# NOINLINE topEntity #-}

testBench :: Signal System Bool
testBench = done
    where 
        testInput = stimuliGenerator clk rst $(listToVecTH [(1,1)::(Signed 8,Signed 8),(2,2),(3,3),(4,4)])
        expectOutput = outputVerifier clk rst $(listToVecTH [0::Signed 8,1,5,14])
        done = expectOutput (topEntity clk rst en testInput)
        en   = enableGen
        clk  = tbSystemClockGen (not <$> done)
        rst  = systemResetGen

