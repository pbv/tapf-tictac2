{-
  Game loop to play Tic-Tac-Toe with two human players
-}
module TAPF.GameLoop (play2) where

import           TAPF.TicTacToe
import qualified Data.Map as Map

-- | start 2-player game
play2 :: IO ()
play2 = do
  endgame <- playLoop (start X)
  printBoard (board endgame)
  print (state endgame)


-- loop until end of game
playLoop :: TicTacToe -> IO TicTacToe
playLoop game
  = case state game of
    Playing player -> do
      m <- askMove player (board game) 
      playLoop (makeMove m game)
    _ -> return game


-- ask next move from user
askMove :: Player -> Board  -> IO Coord
askMove player board 
  = do printBoard board; loop
  where
    coords = freeCoordinates board
    loop = do
      putStrLn ("Player " ++ show player ++ "? ")
      txt <- getLine
      case reads txt of
        [(pos, "")] -> if pos `elem` coords
                       then return pos
                       else do msg; loop
        _ -> do msg; loop
    msg = do
      putStr "invalid move; available moves are: "
      print coords


-- helper functions to print a board
printBoard :: Board -> IO ()
printBoard = putStrLn . showBoard

showBoard :: Board -> String
showBoard b
  = unlines [ [charAt i j | j<-[1..boardSize]]
            | i <- [1..boardSize] ]
  where
    charAt i j = case Map.lookup (i,j) b of
      Just p -> head (show p)
      Nothing -> '.'

