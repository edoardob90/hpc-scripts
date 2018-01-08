
Put[ "pi_result.txt" ]
ParallelTable[N[ Pi, 1000 ],{i,1,4}] >>"pi_result.txt"
Quit[ ]
