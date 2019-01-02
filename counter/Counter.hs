module Counter where


import Clash.Prelude
import Clash.Explicit.Testbench

-- 8 bit counter with Load and Enable
upCounter initState (load,enable,dataIn) = (nextState,initState)
    where
        nextState | load        = dataIn
                  | enable      = initState + 1
                  | otherwise   = initState


topEntity :: Clock System Source
    -> Reset System Asynchronous
    -> Signal System (Bool,Bool,Unsigned 8)
    -> Signal System (Unsigned 8)
topEntity=exposeClockReset $ mealy upCounter 0
{-# NOINLINE topEntity #-}

testBench :: Signal System Bool
testBench = done
    where
        testInput = stimuliGenerator clk rst $(listToVecTH [(True,False,0)::(Bool,Bool,Unsigned 8),(False,True,0),(False,True,0),(False,True,0)])
        expectOutput = outputVerifier clk rst $(listToVecTH [0::Unsigned 8,0,1,2])
        done = expectOutput ( topEntity clk rst testInput)
        clk  = tbSystemClockGen (not <$> done)
        rst  = systemResetGen





