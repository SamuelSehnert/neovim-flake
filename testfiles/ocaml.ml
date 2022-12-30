let rec print_sum acc n =
  if n <= 0
  then Printf.printf "Sum: %d\n" acc
  else print_sum (acc + n) (n - 1)
