module Matrix where

import Prelude as P hiding (length, maximum, (++), replicate)
import Data.Vector as V ((!), length, maximum, map, (++), replicate, fromList)
import Types (Point, Matrix, Transition)

(!!!) :: Matrix -> Point -> Char
(!!!) m (x,y) = m ! x ! y

rows :: Matrix -> Int
rows = length

cols :: Matrix -> Int
cols = maximum . V.map length

outside :: Point -> Int -> Int -> Bool
outside (x,y) r c
  | x < 0   || y < 0   = True
  | x+1 > r || y+1 > c = True
  | otherwise          = False

wrap :: Point -> Int -> Int -> Point
wrap (x,y) r c
  | x < 0     = wrap (r+x, y) r c
  | y < 0     = wrap (x, c+y) r c
  | x+1 > r   = wrap (r-x, y) r c
  | y+1 > c   = wrap (x, c-y) r c
  | otherwise = (x,y)

reflect :: Point -> Int -> Int -> Point
reflect (x,y) r c
  | x < 0     = reflect (0, y)   r c
  | y < 0     = reflect (x, 0)   r c
  | x+1 > r   = reflect (r-1, y) r c
  | y+1 > c   = reflect (x, c-1) r c
  | otherwise = (x,y)

fill :: Matrix -> Matrix
fill m = V.map f m where
         c = cols m
         f r = r ++ (replicate (c - (length r)) ' ')

fromString :: String -> Matrix
fromString = fill . fromList . P.map fromList . lines

step :: Transition -> Matrix -> Matrix
step f m = let r = (rows m) - 1
               c = (cols m) - 1
           in fromList $ P.map fromList [ [f (i,j) m | j <- [0..c]] | i <- [0..r] ]
