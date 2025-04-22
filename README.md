# Advanced LPeg Techniques: A Dual Case Study Approach (JSON & Glob)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This repository contains the code and benchmarks accompanying the preprint:

**Advanced LPeg Techniques: A Dual Case Study Approach**
*Zixuan Zhu*
*doi: 10.20944/preprints202504.1786.v1*
*Link: [https://www.preprints.org/manuscript/202504.1786/v1](https://www.preprints.org/manuscript/202504.1786/v1)*

## Overview

This project explores advanced optimization techniques for Lua Parsing Expression Grammars (LPeg) through two complementary case studies:

1.  **High-performance JSON parser:** An LPeg-based JSON parser optimized using techniques like substitution capture (`{~ ... ~}`) and efficient table construction (`-> make_table`) to rival hand-optimized Lua parsers.
2.  **Sophisticated Glob-to-LPeg converter (`Peglob`):** A converter (`peglob.lua`) that transforms Glob patterns into highly optimized LPeg patterns. It employs techniques like segment-boundary separation, Cox's flattened search strategy (`lookfor`), and optimized braced condition handling (`{a,b}`) to prevent exponential backtracking and achieve high performance and correctness.

The core idea is to demonstrate how strategic grammar construction within LPeg itself can dramatically improve parsing performance without modifying the underlying LPeg C library.

## Key Features & Contributions

*   **Optimized LPeg JSON Parser:** Achieves speeds up to 107.8 MB/s, outperforming `dkjson` and competitive with `rxi_json`. Demonstrates significant benefits from substitution capture and table construction optimization, especially for string-heavy or object-heavy JSON. The key implementation is `lpeg_parser.lua`.
*   **High-Performance & Correct Glob Converter (`Peglob`):** Exhibits 14-92% better performance than Bun.Glob and runs 3-14 times faster than Minimatch on real-world benchmarks (VSCode repository file paths). Maintains high correctness across various Glob features. The main implementation is `peglob.lua`.
*   **Demonstrates Advanced LPeg Optimization Strategies:** Provides practical implementations of powerful optimization techniques discussed in the paper:
    *   **JSON:** Leveraging **substitution captures (`{~...~}`)** for efficient string building (reducing allocation overhead compared to table concatenation) and optimized **function-based table construction (`-> make_table`)** utilizing LuaJIT's `table.new` for better memory management.
    *   **Glob (`Peglob`):** Implementing a **strict segment-boundary separation** architecture, applying **Cox's flattened search strategy** through accumulator captures within the `lookfor` pattern generator, optimizing searches using **first-character analysis (`=> get_first`)** ("skipping false starts"), and introducing a crucial **match-time capture optimization (`=> check_opt`) for braced conditions (`{...}`)** that dynamically limits pattern expansion to prevent catastrophic backtracking.
*   **Extensive Benchmarking:** Includes scripts and data for comparing the implemented parsers against other popular libraries (cjson, dkjson, rxi_json for JSON; Bun.Glob, Minimatch, vimglob, lua-glob for Globs).

## Benchmarks

*   **JSON:** The optimized LPeg parser (`lpeg_parser.lua`) shows competitive performance, especially excelling on structurally complex or string-heavy data compared to other pure Lua parsers.
*   **Glob:** `Peglob` consistently outperforms Bun.Glob and Minimatch on a large, real-world dataset (VSCode source code paths) across various complex patterns. It also demonstrates robustness against backtracking in edge cases due to its optimized design.

Refer to the preprint (Figures 3, 4, 5, 6, 7) for detailed graphs and analysis.

## How to Run

1.  **Dependencies:**
    *   LuaJIT (v2.1.0-beta3 recommended)
    *   LPeg (v1.1.0 recommended)
    *   Bun (for running JavaScript benchmarks like Minimatch, Bun.Glob)

2.  **Running Benchmarks:**
    *   Execute the shell scripts in the root directory:
        *   `./run_json_bench.sh`: Runs JSON parser benchmarks.
        *   `./run_glob_correct.sh`: Runs Glob correctness tests.
        *   `./run_glob_bench.sh`: Runs Glob performance benchmarks against VSCode dataset.
        *   `./run_glob_bench2.sh`: Runs Glob edge-case benchmarks (Figure 7).
    *   Inspect the `.sh` and `call_*.lua` scripts for details on how benchmarks are invoked.

## License

This project is licensed under the **Apache License 2.0**. See the `LICENSE` file for details.

## Citation

If you use the code or concepts from this repository in your research or project, please cite the preprint:

```
@article{zhu2025advanced,
  author = {Zhu, Zixuan},
  title = {Advanced LPeg Techniques: A Dual Case Study Approach},
  journal = {Preprints.org},
  year = {2025},
  doi = {10.20944/preprints202504.1786.v1},
  url = {https://www.preprints.org/manuscript/202504.1786/v1}
}
```
