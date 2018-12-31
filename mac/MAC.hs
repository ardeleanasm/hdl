
module MAC where


import CLaSH.Prelude

ma :: Num a=>a->(a,a)->a
ma acc (x,y) = acc + x * y

macT :: Num a => a -> (a,a) -> (a,a)
macT acc (x,y) = (accumulate,o)
    where
        accumulate = ma acc (x,y)
        o = acc

mac :: Num o => Signal (o,o) -> Signal o
mac = mealy macT 0

topEntity :: Signal (Signed 8, Signed 8) -> Signal (Signed 8)
topEntity = mac

--Tests

testInput :: Signal (Signed 8,Signed 8)
testInput = stimuliGenerator $(listToVecTH [(1,1)::(Signed 8,Signed 8),(2,2),(3,3),(4,4)])

expectedOutput :: Signal (Signed 8) -> Signal Bool
expectedOutput = outputVerifier $(listToVecTH [0::Signed 8,1,5,14])
