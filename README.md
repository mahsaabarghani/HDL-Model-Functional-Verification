# Functional Verification of HDL Models

A multi-phase hardware verification project for an SDRAM controller and its reference model. The project progresses from understanding the design and writing directed tests to random stimulus generation, golden-model comparison, code coverage, functional coverage, checking, and scoreboard-based analysis.

![HDL](https://img.shields.io/badge/HDL-Verilog%20%2F%20SystemVerilog-8B5CF6?style=flat-square)
![Simulator](https://img.shields.io/badge/Simulator-ModelSim-0F766E?style=flat-square)
![Domain](https://img.shields.io/badge/Domain-Hardware%20Verification-EA580C?style=flat-square)
![Design](https://img.shields.io/badge/Design-SDRAM%20Controller-2563EB?style=flat-square)
![Coverage](https://img.shields.io/badge/Focus-Code%20%26%20Functional%20Coverage-7C3AED?style=flat-square)
![Project](https://img.shields.io/badge/Type-Academic%20Project-64748B?style=flat-square)

> **Course:** Functional Verification of HDL Models  \
> **Main subject:** Verification of an SDRAM controller using Verilog/SystemVerilog  \
> **Verification flow:** Directed stimulus → Random stimulus → Golden model → Coverage → Checker and scoreboard

## Overview

The goal of this project is to build a practical verification environment for an SDRAM controller connected to a bus-style interface. The design is exercised with deterministic and random scenarios, compared against an independent golden model, and analyzed using coverage and transaction-level logs.

The Persian course title `درستی‌سنجی مدل‌های HDL` is translated here as **Functional Verification of HDL Models**.

The repository contains the original project deliverables reorganized into clear English folders and file names. The source archives and PDFs on the original drive were preserved; only extracted copies were renamed for this repository.

## Verification flow

```text
Reference SDRAM design
          │
          ▼
System analysis and scenario definition
          │
          ▼
Deterministic stimulus generator
          │
          ▼
Random stimulus generator
          │
          ▼
Golden model and coverage measurement
          │
          ▼
Checker + scoreboard + simulation logs
```

## Repository structure

| Folder | Contents |
| --- | --- |
| [`reference-design/`](reference-design/) | SDRAM controller, SDRAM behavioral model, top-level module, and testbench. |
| [`phase-1-system-understanding/`](phase-1-system-understanding/) | Design analysis, interface description, timing notes, and verification scenarios. |
| [`phase-2-deterministic-stimulus/`](phase-2-deterministic-stimulus/) | Directed stimulus generator and deterministic simulation output. |
| [`phase-3-random-stimulus/`](phase-3-random-stimulus/) | Random/semi-random stimulus generator and simulation output. |
| [`phase-4-golden-model-and-coverage/`](phase-4-golden-model-and-coverage/) | Golden-model report, coverage report, and design-versus-model comparison. |
| [`phase-5-checker-and-scoreboard/`](phase-5-checker-and-scoreboard/) | Checker, scoreboard, golden model, stimulus generator, and verification logs. |
| [`phase-6-functional-coverage/`](phase-6-functional-coverage/) | Supplementary functional-coverage work for deterministic and random scenarios. |
| [`docs/`](docs/) | Project description and functional-coverage assignment documents. |

## Project phases

### Phase 1 - System understanding

This phase analyzes the SDRAM-based reference system before testbench development. It documents the bus signals, timing parameters, read/write behavior, reset behavior, address fields, and possible corner cases.

- [Phase 1 report](phase-1-system-understanding/phase-1-report.pdf)

### Phase 2 - Deterministic stimulus generation

Directed scenarios are used to exercise known behaviors and corner cases, including read and write operations, reset during an active operation, boundary addresses, rapid operations, and idle intervals.

- [Deterministic stimulus generator](phase-2-deterministic-stimulus/deterministic-stimuli-generator.sv)
- [Deterministic simulation output](phase-2-deterministic-stimulus/deterministic-output.txt)
- [Phase 2 report](phase-2-deterministic-stimulus/phase-2-report.pdf)

### Phase 3 - Random stimulus generation

The directed environment is extended with random and semi-random addresses, data values, operation types, and reset timing. This helps explore combinations that are difficult to enumerate manually.

- [Random stimulus generator](phase-3-random-stimulus/random-stimuli-generator.sv)
- [Random simulation output](phase-3-random-stimulus/random-stimuli-output.txt)
- [Phase 3 report](phase-3-random-stimulus/phase-3-report.pdf)

### Phase 4 - Golden model and code coverage

An independent behavioral golden model provides an expected reference for SDRAM transactions. The phase also records ModelSim coverage results and compares the outputs of the design under verification with the golden model.

- [Phase 4 report](phase-4-golden-model-and-coverage/phase-4-report.pdf)
- [Coverage report](phase-4-golden-model-and-coverage/coverage-report.txt)
- [Results comparison](phase-4-golden-model-and-coverage/results-comparison.txt)

The archived coverage report records a total code coverage of **89.43%** for the filtered view. It also records full branch coverage for the golden model and the SDRAM controller, while some FSM transitions and SDRAM-model branches remain uncovered.

### Phase 5 - Checker and scoreboard

This phase completes the verification environment. The checker compares the golden-model and design outputs, while the scoreboard and monitor logs preserve transaction-level evidence for later analysis.

#### Verification code

- [Checker](phase-5-checker-and-scoreboard/codes/checker.sv)
- [Scoreboard](phase-5-checker-and-scoreboard/codes/scoreboard.sv)
- [Golden model](phase-5-checker-and-scoreboard/codes/golden-model.sv)
- [Random stimulus generator](phase-5-checker-and-scoreboard/codes/random-stimuli-generator.sv)

#### Simulation outputs

- [Checker output](phase-5-checker-and-scoreboard/output/checker-output.txt)
- [Deterministic output](phase-5-checker-and-scoreboard/output/deterministic-output.txt)
- [Monitor log](phase-5-checker-and-scoreboard/output/monitor-log.txt)
- [Results comparison](phase-5-checker-and-scoreboard/output/results-comparison.txt)
- [Phase 5 report](phase-5-checker-and-scoreboard/phase-5-report.pdf)

The preserved logs contain `OK`, `Error`, and `Not Ready` transactions. Keeping all three categories makes it possible to inspect both successful comparisons and behaviors that require further debugging.

### Phase 6 - Functional coverage

This supplementary phase focuses on functional coverage for important SDRAM control and data scenarios. It includes deterministic and random stimulus generators together with the written report.

- [Deterministic stimulus generator](phase-6-functional-coverage/deterministic-stimulus-generator.sv)
- [Random stimulus generator](phase-6-functional-coverage/random-stimuli-generator.sv)
- [Phase 6 report](phase-6-functional-coverage/phase-6-report.pdf)

## Reference design

The verification work targets the SDRAM design in [`reference-design/sdram/rtl/`](reference-design/sdram/rtl/):

- [`sdram_controller.v`](reference-design/sdram/rtl/sdram_controller.v)
- [`sdram_model.v`](reference-design/sdram/rtl/sdram_model.v)
- [`sdram_top.v`](reference-design/sdram/rtl/sdram_top.v)
- [`testbench.v`](reference-design/sdram/rtl/testbench.v)

## Tools and concepts

![Verilog](https://img.shields.io/badge/Language-Verilog-111827?style=flat-square)
![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-1D4ED8?style=flat-square)
![ModelSim](https://img.shields.io/badge/EDA-ModelSim-059669?style=flat-square)
![SDRAM](https://img.shields.io/badge/Memory-SDRAM-DC2626?style=flat-square)

- Verilog and SystemVerilog RTL and testbench development
- SDRAM controller and memory-interface behavior
- Directed and constrained-random-style stimulus
- Golden-model reference checking
- Code coverage and functional coverage
- Checker, scoreboard, monitor, and transaction logs

## Running the simulations

The source files are intended for a ModelSim-style workflow. A typical flow is:

```tcl
vlog <design-files> <testbench-files>
vsim <top-level-testbench>
run -all
```

For coverage-enabled runs, use the simulator's coverage option and generate a report after simulation. The exact top-level module and file list may differ between phases; the phase folder and its report should be used as the source of truth for that phase.

## Reference documents

- [Project description](docs/project-description.pdf)
- [Functional coverage assignment](docs/functional-coverage-assignment.pdf)

## Repository notes

- The project is organized for academic documentation and review.
- Generated logs and reports are kept with the phase that produced them.
- File names were normalized to English for easier navigation on GitHub.
- No license was added because this repository contains coursework rather than a separately licensed software package.
