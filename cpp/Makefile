CC = clang++ -std=c++11

# bundle all
all:   \
	ac \

clean:
	rm -f ac

ac : associative_container.cpp
	$(CC) -o $@ associative_container.cpp
