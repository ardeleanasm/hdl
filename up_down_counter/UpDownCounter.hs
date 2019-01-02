module UpDownCounter where


import Clash.Prelude
import Clash.Explicit.Testbench

-- 8 bit counter with Load and Enable
upDownCounter initState (load,enable,direction,dataIn) = (nextState,initState)
    where
        nextState | load                        = dataIn
                  | (enable && direction)         = initState + 1
                  | (enable && (not direction))   = initState - 1
                  | otherwise                   = initState


topEntity :: Clock System Source
    -> Reset System Asynchronous
    -> Signal System (Bool,Bool,Bool,Unsigned 8)
    -> Signal System (Unsigned 8)
topEntity=exposeClockReset $ mealy upDownCounter 0
{-# NOINLINE topEntity #-}

testBench :: Signal System Bool
testBench = done
    where
        testInput = stimuliGenerator clk rst $(listToVecTH [
                                (True,False,True,0)::(Bool,Bool,Bool,Unsigned 8)
                                ,(False,True,True,0)
                                ,(False,True,True,0)
                                ,(False,True,True,0)
                                ,(False,True,True,0)
                                ])
        expectOutput = outputVerifier clk rst $(listToVecTH [0::Unsigned 8,0,1,2,1])
        done = expectOutput ( topEntity clk rst testInput)
        clk  = tbSystemClockGen (not <$> done)
        rst  = systemResetGen





