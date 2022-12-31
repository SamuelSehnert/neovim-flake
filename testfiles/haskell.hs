bubbleSort :: Ord a => [a] -> [a]
bubbleSort xs = foldr swapTill xs [1..length xs-1]

swapTill :: Ord a => Int -> [a] -> [a]
swapTill 0 = id
swapTill count = \(x:y:xs) -> min x y : swapTill (count-1) (max x y:xs)
