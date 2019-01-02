module Counter where


import Clash.Prelude

-- 8 bit counter with Load and Enable
upCounter initState (load,enable,dataIn) = (nextState,initState)
    where
        nextState | load        = dataIn
                  | enable      = initState + 1
                  | otherwise   = initState

--counter :: HiddenClockReset domain gated synchronous
--        => Signal domain ( Bool,Bool,Unsigned 8)
--        -> Signal domain ( Unsigned 8)
counter :: Num o => Signal (Bool,Bool,Unsigned 8)
        -> Signal (Unsigned 8)
counter = mealy upCounter 0 


--topEntity :: Signal (Bool,Bool,Unsigned 8) -> Signal (Unsigned 8)
topEntity :: Clock System Source
    -> Reset System Asynchronous
    -> Signal System (Bool,Bool,Unsigned 8)
    -> Signal System (Unsigned 8)
topEntity=counter





