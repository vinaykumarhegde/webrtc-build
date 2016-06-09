CC=g++

LIBJINGLE_VER?=a4ef2ce
LIBJINGLE_CFLAGS=$(shell pkg-config --cflags-only-other libjingle${LIBJINGLE_VER})
LIBJINGLE_INCLUDES=$(shell pkg-config --cflags-only-I libjingle${LIBJINGLE_VER})
LIBJINGLE_LDFLAGS=
LIBJINGLE_LIBS=$(shell pkg-config --libs libjingle${LIBJINGLE_VER})
LIBJINGLE_STATIC_LIBS=-l:libjingle.a $(shell pkg-config --libs-only-L libjingle${LIBJINGLE_VER}) $(shell pkg-config --libs --static libjingle${LIBJINGLE_VER})

CFLAGS=-g -O0 -std=c++11 -Wall ${LIBJINGLE_CFLAGS}
INCLUDES=${LIBJINGLE_INCLUDES}
LDFLAGS=

SRCS=test.cpp
OBJS=$(SRCS:.cpp=.o)

all: test-static test-dynamic

test-static: $(OBJS)
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $(OBJS) $(LDFLAGS) $(LIBJINGLE_STATIC_LIBS)

test-dynamic: $(OBJS)
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $(OBJS) $(LDFLAGS) $(LIBJINGLE_LIBS)

.cpp.o:
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

clean:
	$(RM) *.o *~ test-static test-dynamic
