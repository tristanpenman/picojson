prefix=/usr/local
includedir=$(prefix)/include

check: test

test: test-core test-core-int64
	./test-core
	./test-core-int64

picotest.o: picotest/picotest.c picotest/picotest.h
	$(CC) $(CFLAGS) -Wall -c picotest/picotest.c -o picotest.o

test-core: picojson.h test.cc picotest.o
	$(CXX) $(CXXFLAGS) -std=c++11 -Wall test.cc picotest.o -o $@

test-core-int64: picojson.h test.cc picotest.o
	$(CXX) $(CXXFLAGS) -std=c++11 -Wall -DPICOJSON_USE_INT64 test.cc picotest.o -o $@

clean:
	rm -f test-core test-core-int64 picotest.o

install:
	install -d $(DESTDIR)$(includedir)
	install -p -m 0644 picojson.h $(DESTDIR)$(includedir)

uninstall:
	rm -f $(DESTDIR)$(includedir)/picojson.h

clang-format: picojson.h examples/github-issues.cc examples/iostream.cc examples/streaming.cc
	clang-format -i $?

.PHONY: test check clean install uninstall clang-format
