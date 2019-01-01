module Decoder where

import CLaSH.Prelude
import qualified CLaSH.Sized.Internal.BitVector as BV

decoder::Bool -> BitVector 4 -> BitVector 16
decoder enable binaryIn 
    | enable =
        case binaryIn of 
            0x00 -> 0x0000
            0x01 -> 0x0001    
            0x02 -> 0x0002 
            0x03 -> 0x0003
            0x04 -> 0x0004
            0x05 -> 0x0005
            0x06 -> 0x0006
            0x07 -> 0x0007 
            0x08 -> 0x0008 
            0x09 -> 0x0009
            0x0A -> 0x000A
            0x0B -> 0x000B
            0x0C -> 0x000C
            0x0D -> 0x000D
            0x0E -> 0x000E
            0x0F -> 0x000F
    | otherwise = 0

encoder :: Bool -> BitVector 16 -> BitVector 4
encoder enable binaryIn
    | enable =
        case binaryIn of
            0x0000 -> 0x00
            0x0001 -> 0x01
            0x0002 -> 0x02
            0x0003 -> 0x03
            0x0004 -> 0x04
            0x0005 -> 0x05
            0x0006 -> 0x06
            0x0007 -> 0x07
            0x0008 -> 0x08
            0x0009 -> 0x09
            0x000A -> 0x0A
            0x000B -> 0x0B
            0x000C -> 0x0C
            0x000D -> 0x0D
            0x000E -> 0x0E
            0x000F -> 0x0F
    | otherwise = 0

multiplexer :: BitVector 4 -> BitVector 2-> Bit
multiplexer input select = 
    BV.index# input $ fromIntegral $ BV.toInteger# select
    
