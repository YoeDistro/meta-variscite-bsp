do_compile() {
	# Linux kernel build system is expected to do the right thing
	unset CFLAGS
        test -e ${S}/tools/lib/traceevent/plugins/Makefile && \
            sed -i -e 's|\$(libdir)/traceevent/plugins|\$(libdir)/traceevent_${KERNEL_VERSION}/plugins|g' ${S}/tools/lib/traceevent/plugins/Makefile
	test -e ${S}/tools/perf/Makefile.config && \
            sed -i -e 's|\$(libdir)/traceevent/plugins|\$(libdir)/traceevent_${KERNEL_VERSION}/plugins|g' ${S}/tools/perf/Makefile.config
	# There are two copies of internal headers such as:
	# libperf/include/internal/xyarray.h and tools/lib/perf/include/internal/xyarray.h
	# For reproducibile binaries, we need to find one copy, hence force libXXX to be created first
	#for i in api bpf subcmd symbol perf
	#do
	#	oe_runmake -C ${S}/tools/lib/$i DESTDIR=${B}/lib$i prefix= install_headers V=1
	#done
	oe_runmake all V=1
}
