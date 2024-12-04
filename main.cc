#include <iostream>
#include <seastar/core/app-template.hh>
#include <seastar/core/reactor.hh>

// Pulled from https://docs.seastar.io/master/tutorial.html#threads-and-memory
int main(int argc, char **argv) {
  seastar::app_template app;
  app.run(argc, argv, [] {
    // Memory limits would be read from something in here:
    // https://github.com/scylladb/seastar/blob/b63b02a1f674a96365ec688f257294cebac3b865/src/core/resource.cc#L241
    std::cout << "CPUs (smp): " << seastar::smp::count << "\n";
    std::cout << "Free memory: " << seastar::memory::free_memory() << "\n";
    return seastar::make_ready_future<>();
  });
}
