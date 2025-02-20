C_FLAGS = -std=c99 -fPIC -O2 -Iinclude

all: libaxidma.so

clean:
	rm -rf *.so *.o

libaxidma.so: axi_dma_api.c
	${CC} -shared -o $@ $<
