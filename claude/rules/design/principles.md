# Design Principles

These principles guide design decisions.
They are decision criteria, not independent goals to maximize.

Detailed operational guidelines that apply these principles are maintained in `~/.claude/references/design/guidelines.md`.
Read that file, if present, before any of the following:

- Making a non-trivial design decision — for example, introducing or changing a public or cross-component interface, schema, contract, or external dependency, or making a change that spans multiple modules.
- Performing a design review.
- Resolving a conflict between principles.

Do not load it for tasks that involve no design decisions.

## Conflict Priority

When principles conflict, apply the following priority:

1. Do not violate security, data integrity, or requirements explicitly designated as non-negotiable.
   (Security by Default; the aspects of Correctness that protect authoritative state and stored data)
2. Satisfy explicitly required behavior, acceptance criteria, and failure semantics, and preserve applicable invariants.
   Applicable invariants include both stated invariants and those inherent in the existing design.
   (Correctness; Fault Tolerance)
3. Preserve contracts that have consumers — public or internal — and their compatibility, unless the task requires changing them.
   (Compatibility and Contract Evolution)
4. Prefer the least complex reversible design that satisfies the requirement.
   When simplicity and reversibility conflict:
   - Prefer the reversible design if its added complexity is reasonable.
   - Otherwise prefer the simpler one.
   (Simplicity; Design for Change)
5. Follow established local conventions.
   (Consistency)
6. Do not add abstraction, configurability, or other mechanism beyond what a demonstrated requirement or risk justifies.
   (Simplicity; Abstraction; Design for Change)

Levels 4 and 6 apply Simplicity and Design for Change in different roles:
level 4 selects among candidate designs; level 6 constrains adding mechanism to the chosen design.

## Design-Quality Criteria

The remaining principles are design-quality criteria, not additional priority levels:
Separation of Concerns, Abstraction, Explicit over Implicit, Single Source of Truth, Predictability, Resource Awareness, and Diagnosability and Verifiability.

How design-quality criteria relate to the priority levels:

- They select among designs that levels 1–6 leave open.
- On their own, they do not justify departing from local conventions (level 5) or introducing additional mechanism (level 6).
- Any of them is elevated to level 2 where the requirements explicitly demand it — for example, a stated reproducibility, capacity, or observability requirement.
- When design-quality criteria conflict with each other, prefer the least complex reversible option (level 4).

Abstraction has two roles:

- Whether to introduce an abstraction at all is governed by level 6.
- The shape and ownership of boundaries the design already includes are design-quality concerns.

## Worked Examples

These examples illustrate how the priority levels combine; they add no new rules.

- A refactor would be simpler if it renamed a configuration key that existing consumers read.
  Level 3 outranks level 4: keep the key, or change it only with an explicit migration path — a simpler design does not justify breaking a consumed contract.
- A new module could be given a plugin interface "in case other backends are added later".
  No requirement or demonstrated risk calls for a substitution point, so level 6 rejects the interface; Design for Change alone is not a justification.
  If a second backend later becomes a real requirement, that requirement justifies introducing the substitution point at that time.

## Principle Definitions

Each definition fixes the intended interpretation of the name used above: the first line is the core definition, and the bullets refine it.
The operational detail lives in the guidelines file.
Numbered references in this document always mean the priority levels above.

### Correctness

Satisfy the stated requirements, invariants, and applicable boundary and failure cases, and leave authoritative state and stored data consistent.

- Compiling and passing existing tests are not evidence of correctness.

### Security by Default

Never weaken security controls for implementation, testing, or deployment convenience.

- Treat data as untrusted whenever its integrity or origin is not guaranteed — including data from external systems, internal services, storage, configuration, plugins, tools, and generated outputs.

### Compatibility and Contract Evolution

Contracts include persisted data, messages, configuration, command-line behavior, error semantics, and operational behavior, not only APIs.

- A contract change requires an explicit migration path.
- Compatibility mechanisms and deprecations require explicit removal conditions.

### Fault Tolerance

Failure behavior is part of correctness.

- Leave the system in a defined state, make retries safe or explicitly unsafe, and prevent recovery mechanisms from amplifying failures.
- Inherent failure modes of the operations involved — hangs, duplicate effects, partial failure, unbounded retry growth — count as demonstrated risks at level 6 even when no requirement names them.
- The mechanism addressing such a risk must still be proportionate to the risk.

### Simplicity

The least mechanism that satisfies the current requirement.

- Boundaries that protect a demonstrated contract, invariant, or risk are not complexity.

### Separation of Concerns

Separate what changes for different reasons; keep together what consistently changes together.

- Decides where responsibilities belong; Abstraction decides how they are exposed.

### Abstraction

The shape and ownership of boundaries, not the number of layers.

- Introduce one only for a demonstrated need — for example, to isolate volatility, prevent implementation leakage, or provide a required substitution point — never for hypothetical reuse.

### Explicit over Implicit

Behavior must be traceable to explicit inputs, declared dependencies, and documented contracts — not to ambient state, initialization order, or undocumented framework behavior.

### Single Source of Truth

One authoritative source per shared fact within its ownership boundary.

- Derived copies are acceptable when their synchronization is defined.
- Narrower than DRY: do not centralize coincidentally equal values.

### Design for Change

Prefer reversible decisions; isolate volatile decisions only with evidence they will vary.

- Not a reason to generalize.

### Predictability

Same controlled inputs and state, same observable result.

- Make unavoidable variation explicit and controllable where reproducibility is required.

### Resource Awareness

Cost in proportion to the problem: neither speculative optimization nor accepted obvious or unbounded inefficiency.

- Justify significant optimizations with measurement or realistic estimates.

### Consistency

Follow local conventions unless they preserve a defect or violate a higher-priority principle.

- Prefer local consistency over repository-wide uniformity.

### Diagnosability and Verifiability

Surface failures close to their cause with actionable context.

- Make behavior verifiable without relying on unrelated parts of the system.
