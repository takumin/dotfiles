---
name: crate-responsibility-audit
description: >
Audit a Rust application or Cargo workspace for crate responsibility,
architectural boundaries, dependency direction, public API cohesion,
change coupling, and excessive crate fragmentation. Use when asked to
review "one crate, one responsibility", crate boundaries, workspace
structure, crate splitting or merging, dependency isolation, framework
leakage, unsafe isolation, or Rust application architecture. This skill
performs a read-only cross-cutting investigation with multiple subagents
and returns an evidence-based report. It must not modify files.
---

# Crate Responsibility Audit

Audit the current Rust repository to determine whether each crate has:

- one clear architectural responsibility;
- one primary reason to change;
- an appropriate dependency boundary;
- a cohesive public API;
- sufficient independence to justify being a separate crate.

Interpret “one crate, one responsibility” as:

> One crate should represent one architectural boundary and have one primary
> reason to change.

Do not interpret it as:

- one crate per feature;
- one crate per type;
- one crate per module;
- one crate per operation;
- one crate per directory.

Modules, types, and traits should normally handle internal responsibility
separation. Recommend a new crate only when a compile-time, dependency,
platform, safety, API, testing, deployment, or implementation boundary is
materially useful.

## Operating constraints

This is a read-only audit.

Do not:

- edit source files;
- edit manifests;
- generate patches;
- run formatting;
- update dependencies;
- create branches or commits;
- recommend changes based only on crate names or line counts;
- assume that a small crate should be merged;
- assume that a large crate should be split;
- propose generic `common`, `shared`, `utils`, `base`, or `types` crates
  without a narrowly defined responsibility.

Read-only commands such as the following are allowed when available:

- `cargo metadata`;
- `cargo tree`;
- `cargo test --no-run`;
- `git log`;
- `git diff`;
- `git grep`;
- repository-specific inspection commands that do not modify the working tree.

Do not run expensive builds or tests unless they are necessary to validate a
specific architectural finding.

Ignore:

- `target/`;
- vendored dependencies;
- generated code;
- build artifacts;
- lockfile-only dependency update commits;
- purely mechanical formatting commits when analyzing change coupling.

## Audit procedure

### 1. Establish the repository scope

Locate the repository root and inspect:

- the root `Cargo.toml`;
- workspace members and exclusions;
- package manifests;
- `src/lib.rs`;
- `src/main.rs`;
- `build.rs`;
- examples, benches, tests, fixtures, and support crates;
- feature definitions;
- platform-specific dependencies;
- optional dependencies;
- proc-macro crates;
- binary-only wrapper crates;
- internal path dependencies.

Create an initial workspace inventory containing:

- crate name;
- crate type;
- intended role inferred from code and documentation;
- major internal and external dependencies;
- public API surface;
- platform or framework coupling;
- approximate source scope;
- principal consumers.

Do not treat the initial inferred role as a conclusion. It is a hypothesis that
must be verified by the delegated investigations.

### 2. Launch independent subagents

Launch four read-only subagents in parallel when the environment supports it.

Each subagent must inspect the entire relevant workspace from its assigned
perspective. Do not assign one subagent per crate unless the repository is too
large to inspect effectively as a whole.

Each subagent must:

- avoid modifying files;
- cite concrete evidence using `path:line`;
- distinguish observations from interpretations;
- identify uncertainty explicitly;
- report both healthy boundaries and suspected problems;
- assign a confidence level to each finding;
- return a structured report to the parent agent;
- avoid delegating further unless explicitly necessary.

#### Subagent A: dependency-boundary investigator

Investigate Cargo-level and architectural dependency boundaries.

Inspect:

- workspace manifests;
- path dependencies;
- dependency direction;
- optional dependencies;
- feature propagation;
- default features;
- build dependencies;
- dev dependencies;
- framework dependencies;
- platform dependencies;
- duplicate abstractions;
- dependency inversion boundaries.

Determine whether:

- domain or core crates depend on delivery frameworks;
- low-level crates depend on higher-level application concerns;
- unrelated external dependencies are bundled into one crate;
- feature flags are compensating for missing crate boundaries;
- crates exist only to avoid an otherwise artificial dependency cycle;
- implementation crates are cleanly separated from interfaces where useful;
- thin crates add meaningful dependency isolation;
- public APIs expose third-party implementation details unnecessarily.

Report:

1. the observed dependency structure;
2. healthy dependency boundaries;
3. suspected boundary violations;
4. evidence for possible split or merge candidates;
5. confidence and unresolved questions.

#### Subagent B: cohesion and public-API investigator

Investigate the semantic cohesion of each crate.

Inspect:

- crate-level documentation;
- `lib.rs` and `main.rs`;
- module trees;
- public types;
- public traits;
- public functions;
- error types;
- configuration types;
- re-exports;
- feature-gated APIs;
- internal ownership of domain concepts.

For every significant crate, attempt to describe its responsibility in one
sentence.

Flag a crate when its responsibility can only be described using unrelated
clauses such as:

> Handles authentication, archive parsing, HTTP responses, and storage.

Do not flag a crate merely because its responsibility contains multiple
closely related operations.

Determine whether:

- the public API presents one coherent capability;
- unrelated domain concepts are owned by the same crate;
- the crate mixes policy and infrastructure;
- the crate mixes reusable library logic with process startup;
- a facade crate deliberately presents a coherent API over several internal
  crates;
- an allegedly reusable crate depends on application-specific concepts;
- internal modules would be more appropriate than additional crates;
- `common`, `shared`, `utils`, or `types` crates have become responsibility
  dumping grounds.

Report:

1. a one-sentence responsibility for each significant crate;
2. cohesive and intentionally broad crates;
3. crates with multiple unrelated reasons to change;
4. crates whose public API does not match their stated role;
5. possible module-level remedies that do not require crate splitting;
6. confidence and unresolved questions.

#### Subagent C: change-coupling investigator

Use version-control history when meaningful history is available.

Analyze a representative set of recent non-mechanical commits. Prefer at least
100 relevant commits when the repository contains sufficient history.

Exclude or discount:

- dependency bot updates;
- generated-code updates;
- repository-wide formatting;
- license-header changes;
- large mechanical renames;
- release-only metadata changes.

Investigate:

- crates that nearly always change together;
- changes that repeatedly cross supposed crate boundaries;
- crates that evolve independently;
- unrelated concerns repeatedly modified inside one crate;
- public API changes that force widespread workspace changes;
- test changes that reveal actual ownership boundaries;
- split crates with no independent history;
- crates with distinct release or compatibility pressures.

Do not treat historical co-change as proof by itself. A healthy API migration,
large refactoring, or repository-wide policy change can temporarily produce
high coupling.

Report:

1. observed co-change patterns;
2. crates with genuinely independent evolution;
3. crates whose separation appears artificial;
4. crates containing unrelated change clusters;
5. representative commits or history evidence;
6. limitations of the available history;
7. confidence and unresolved questions.

#### Subagent D: cross-cutting-boundary investigator

Investigate boundaries that commonly justify separate crates.

Inspect:

- `unsafe` code;
- FFI;
- operating-system APIs;
- architecture-specific code;
- file formats and parsers;
- network protocols;
- database and cloud SDKs;
- HTTP frameworks;
- CLI frameworks;
- serialization formats;
- authentication;
- storage backends;
- logging and telemetry;
- proc macros;
- build scripts;
- test-support infrastructure;
- executable startup and composition roots.

Determine whether:

- `unsafe` or FFI is isolated behind a safe interface;
- platform-specific code is contained;
- external SDKs leak into core logic;
- replaceable implementations have explicit boundaries;
- protocol adapters are separated from application policy;
- testing support is incorrectly part of production crates;
- build-time and runtime responsibilities are mixed;
- serialization DTOs are incorrectly used as domain models;
- multiple adapters are grouped because they implement one coherent port;
- adapter crates are too fine-grained to provide meaningful isolation.

Report:

1. existing safety, platform, and infrastructure boundaries;
2. missing boundaries;
3. unnecessary boundaries;
4. implementation leakage;
5. specific split, merge, or containment candidates;
6. confidence and unresolved questions.

### 3. Verify and reconcile the reports

After receiving all subagent reports:

1. Verify every high-severity finding directly.
2. Merge duplicate findings.
3. Preserve meaningful disagreements between subagents.
4. Prefer findings supported by multiple independent perspectives.
5. Downgrade findings based only on naming, file size, or subjective style.
6. Separate current defects from future scalability concerns.
7. Separate architectural problems from code-quality problems.
8. Avoid recommending a crate split where a module boundary is sufficient.

For each significant crate, assign one result:

- **Keep** — the existing boundary is justified;
- **Split** — multiple responsibilities require distinct dependency or API
  boundaries;
- **Merge** — separate crates provide little isolation and evolve as one unit;
- **Refactor internally** — the problem exists, but module or type boundaries
  are sufficient;
- **Observe** — evidence is insufficient or the boundary may become useful
  later.

### 4. Apply decision criteria

A split recommendation normally requires at least two strong signals:

- unrelated primary reasons to change;
- materially different external dependencies;
- platform-specific or unsafe code requiring isolation;
- independently reusable capability;
- independently replaceable implementation;
- distinct public API or compatibility contract;
- independent test or release lifecycle;
- framework leakage into core logic;
- repeated unrelated change clusters;
- separate deployment or execution role.

A merge recommendation normally requires at least two strong signals:

- crates always change together;
- one crate is unusable without the other;
- no meaningful dependency isolation exists;
- the split forces unnecessary public APIs;
- types are repeatedly forwarded or re-exported without abstraction;
- crate boundaries mirror internal implementation details;
- the split creates excessive manifest or feature coordination;
- the crates share one compatibility and release lifecycle.

Do not recommend merging a small crate when it provides a valuable:

- `unsafe` boundary;
- FFI boundary;
- proc-macro boundary;
- platform boundary;
- dependency isolation boundary;
- test-support boundary;
- binary composition boundary.

### 5. Produce the final report

Use the following format.

# Crate Responsibility Audit

## Executive summary

State:

- overall architectural assessment;
- whether crate boundaries are broadly appropriate;
- the most important finding;
- the number of Keep, Split, Merge, Refactor internally, and Observe results.

## Evaluation standard

Explain briefly that the audit evaluates one architectural responsibility and
one primary reason to change, rather than one feature or one module per crate.

## Workspace map

| Crate | Current responsibility | Major dependencies | Main consumers | Initial assessment |
| ----- | ---------------------- | ------------------ | -------------- | ------------------ |

## Confirmed strengths

List healthy boundaries that should be preserved.

Include evidence.

## Findings

Order findings by architectural impact.

For every finding use:

### `[severity] Finding title`

- **Affected crates:** names
- **Classification:** Split / Merge / Refactor internally / Observe
- **Observation:** directly observed facts
- **Evidence:** `path:line`, manifest relationships, or representative commits
- **Interpretation:** why the evidence matters
- **Impact:** practical consequence
- **Recommendation:** concrete direction without implementing it
- **Alternatives:** module-level or lower-cost alternatives where applicable
- **Confidence:** High / Medium / Low

Severity values:

- **Critical** — unsafe, platform, or dependency boundary creates an immediate
  correctness or maintainability risk;
- **High** — crate boundary materially violates dependency or ownership rules;
- **Medium** — boundary creates recurring coupling or unnecessary complexity;
- **Low** — naming, documentation, or future maintainability concern.

## Per-crate verdict

| Crate | Verdict | Primary reason to change | Rationale | Recommended next action |
| ----- | ------- | ------------------------ | --------- | ----------------------- |

Every significant crate must appear exactly once.

## Proposed target structure

Include this section only when at least one high-confidence structural change
is justified.

Show:

- proposed crate names;
- one-sentence responsibility of each crate;
- allowed dependency direction;
- concepts moved between crates;
- boundaries intentionally left as modules.

Do not invent abstract `common`, `shared`, or `types` crates.

## Dependency rules

List concrete dependency rules that could later be documented or enforced.

Examples:

- domain crates must not depend on HTTP frameworks;
- safe crates must forbid unsafe code;
- platform crates may depend on OS APIs but expose portable interfaces;
- binaries may perform composition but must not own reusable business logic.

Only include rules supported by the repository’s actual architecture.

## Uncertainties and limitations

Document:

- missing history;
- incomplete documentation;
- generated code;
- unavailable build tooling;
- ambiguous ownership;
- findings that require maintainer intent to resolve.

## Final verdict

Conclude with one of:

- **Boundaries are appropriate**
- **Mostly appropriate with local corrections**
- **Over-fragmented**
- **Under-separated**
- **Mixed structural issues**

Do not finish with generic advice. State the specific architectural condition
of the inspected repository.

## No-issue case

When no material issue is found:

- explicitly confirm that the current crate boundaries are justified;
- identify the evidence supporting that conclusion;
- avoid inventing changes to make the report appear useful;
- note only concrete monitoring points for future growth.
