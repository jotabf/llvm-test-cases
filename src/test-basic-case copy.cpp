#include <omp-tools.h>
#include <omp.h>
#include <stdio.h>

#include <omp-tools.h>
#include <stdio.h>

// Define the finalize function
void my_ompt_finalize(ompt_data_t *tool_data) {
  printf("Finalizing OMPT Tool.\n");
  // Perform cleanup here
}

// Initialize OMPT tool
int ompt_initialize(ompt_function_lookup_t lookup, int initial_device_num,
                    ompt_data_t *tool_data) {
  printf("Initializing OMPT Tool.\n");

  // Lookup the finalize function and register it
  ompt_finalize_t ompt_finalize = (ompt_finalize_t)lookup("ompt_finalize");
  if (ompt_finalize) {
    ompt_finalize(tool_data);
  }

  // Other initialization code here
  return 1; // Return non-zero to indicate success
}

// Finalize OMPT tool
void ompt_finalize(ompt_data_t *tool_data) {
  printf("OMPT Tool is being finalized.\n");
  // Cleanup code
}

// OMPT tool interface version
ompt_start_tool_result_t *ompt_start_tool(unsigned int omp_version,
                                          const char *runtime_version) {
  static ompt_start_tool_result_t result = {&ompt_initialize, &ompt_finalize,
                                            0};
  return &result;
}

void func() {
  int a = 0;
  printf("Initing\n");
  #pragma omp parallel
    { a++; }
  printf("a = %d\n", a);
}

int main() {
  for (size_t i = 0; i < 10; i++) {
    func();
  }

  func();

  return 0;
}