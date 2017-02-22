{-|
  Game positions, trees and Minimax algorithm
  Pedro Vasconcelos
  Based on chap. 9 of "Introduction to Functional Programming",
  by Richard Bird and Philip Wadler, 1988
-}
module TAPF.GameTree where

-- | a type class for game positions
class GamePosition p where
  -- | next game positions; empty if the game has ended
  successors :: p -> [p]
  -- | valuation for a position
  -- from the point-of-view of the *active* player
  valuation :: p -> Int


-- | "Rose" trees, i.e. trees with variable number of children
data Tree a = Node a [Tree a] deriving (Eq, Show)

-- | Unfold a game tree from a given position
-- because of lazy evaluation, the tree will be expanded on demand;
-- this is useful for games with large even infinite trees
gameTree :: GamePosition p => p -> Tree p
gameTree g = Node g (map gameTree (successors g))


-- | apply a function to a tree
mapTree :: (a -> b) -> Tree a -> Tree b
mapTree f (Node x children) = Node (f x) (map (mapTree f) children)

-- | prune a tree to a given depth
prune :: Int -> Tree a -> Tree a
prune n (Node x ts)
  | n>0       = Node x (map (prune (n-1)) ts)
  | otherwise = Node x []

-- | compute the approximate minimax value up-to a given depth
minimaxValue :: GamePosition p => Int -> p -> Int
minimaxValue depth
  = minimax . mapTree valuation . prune depth . gameTree

-- | compute the minimax value for a finite tree
minimax :: Tree Int -> Int
minimax (Node x []) = x
minimax (Node _ ts) = - minimum (map minimax ts)
