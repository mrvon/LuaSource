min_num = 2
max_num = 100

prime_list = []

for i in range(min_num, max_num):
    is_prime = True
    for j in range(2, i - 1):
        if i % j == 0:
            is_prime = False
            break
    if is_prime:
        prime_list.append(str(i))

print(" ".join(prime_list))
