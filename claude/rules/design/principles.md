# Design Principles

These principles guide design decisions. They are decision criteria, not independent goals to maximize.

Detailed operational guidelines that apply these principles are maintained in `~/.claude/references/design/guidelines.md`. Read that file before making non-trivial design decisions, performing design reviews, or resolving conflicts between principles; do not load it for tasks that involve no design decisions.

When principles conflict, apply the following priority:

1. Do not violate security, data integrity, or other non-negotiable requirements, including any applicable safety constraints. (Security by Default; the aspects of Correctness that protect authoritative state and stored data)
2. Satisfy explicitly required behavior, invariants, acceptance criteria, and failure semantics. (Correctness; Fault Tolerance)
3. Preserve public contracts and compatibility unless the task requires changing them. (Compatibility and Contract Evolution)
4. Prefer the least complex reversible design that satisfies the requirement. When simplicity and reversibility conflict, prefer the reversible design if its added complexity is reasonable; otherwise prefer the simpler one. (Simplicity; Design for Change)
5. Follow established local conventions. (Consistency)
6. Do not add abstraction, configurability, or other mechanism beyond what a demonstrated requirement or risk justifies. (Simplicity; Abstraction; Design for Change)

Levels 4 and 6 apply Simplicity in different roles: level 4 selects among candidate designs; level 6 constrains adding mechanism to the chosen design.

The remaining principles — Separation of Concerns, Explicit over Implicit, Single Source of Truth, Predictability, Resource Awareness, and Diagnosability — are design-quality criteria, not additional priority levels. They select among designs that levels 1–6 leave open; on their own they do not justify departing from local conventions (level 5) or introducing additional mechanism (level 6). Any of them is elevated to level 2 where the requirements explicitly demand it — for example, a stated reproducibility, capacity, or observability requirement. When design-quality criteria conflict with each other, prefer the least complex reversible option (level 4).

## 1. Correctness

Preserve required behavior, invariants, data integrity, and contracts.

A solution is not correct merely because it compiles or passes existing tests. The implementation must satisfy the stated requirements, preserve relevant invariants, handle applicable boundary and failure cases, and leave authoritative state consistent.

## 2. Security by Default

Protect trust boundaries, credentials, authorization decisions, sensitive data, and security-critical operations explicitly.

Do not weaken security controls to simplify implementation, testing, or deployment. Treat data as untrusted whenever its integrity or origin is not guaranteed, including data received from external systems, internal services, storage, configuration, plugins, tools, or generated outputs.

## 3. Compatibility and Contract Evolution

Preserve externally observable contracts unless changing them is required.

Treat APIs, persisted data, messages, configuration, command-line behavior, error semantics, and relevant operational behavior as contracts. When a contract must change, make the compatibility strategy, migration path, rollout constraints, and removal conditions explicit.

## 4. Fault Tolerance

Assume that networks, external services, infrastructure, and dependent operations can fail, become slow, or become overloaded.

Failure behavior is part of correctness. Define what happens when an operation cannot complete, leave the system in a defined state, make retries safe or explicitly unsafe, and prevent recovery mechanisms from amplifying failures.

## 5. Simplicity

Build only what is needed.

Simplicity evaluates the amount of mechanism required by the current design. Prefer the least complex solution that correctly satisfies the current requirement. Avoid speculative generality, unnecessary indirection, and mechanisms that do not solve a demonstrated problem.

Simplicity does not prohibit boundaries or abstractions that protect a demonstrated contract, invariant, or risk.

## 6. Separation of Concerns

Keep responsibilities that change for different reasons in separate units.

Separate policy from mechanism, domain logic from infrastructure, and computation from side effects. Keep responsibilities together when they are operationally coupled, share the same invariants or lifecycle, and consistently change together.

Separation of Concerns determines where responsibilities belong. Abstraction determines how those responsibilities are exposed across boundaries.

## 7. Abstraction

Hide incidental complexity and expose intent through stable boundaries.

Abstraction concerns the shape and ownership of boundaries, not the number of layers. Introduce abstractions where they clarify domain concepts, isolate volatility, prevent implementation leakage, enforce a meaningful architectural boundary, or provide a required substitution point.

Do not create abstractions solely in anticipation of hypothetical reuse or change.

## 8. Explicit over Implicit

Make behavior traceable to explicit inputs, declared dependencies, configuration, contracts, or documented conventions.

Avoid hidden dependencies, ambient state, surprising side effects, and control flow that depends on initialization order, undocumented framework behavior, or other implicit conditions.

## 9. Single Source of Truth

Maintain one authoritative source for each shared semantic fact, rule, schema, or decision within its ownership boundary.

Derived, cached, generated, indexed, replicated, or denormalized representations are acceptable when their relationship to the authoritative source is explicit and their synchronization, invalidation, rebuilding, or reconciliation is defined.

## 10. Design for Change

Keep the cost and scope of demonstrated or high-risk changes low.

Prefer reversible decisions, stable boundaries, and localized dependencies. Isolate volatile decisions when there is evidence that they will vary or when failure to isolate them would create significant cost or risk.

Design for Change is not a reason to generalize every implementation.

## 11. Predictability

Make behavior reproducible and understandable.

Given the same controlled inputs and state, a system should produce the same observable result. Make unavoidable sources of variation explicit and controllable where determinism or reproducibility is required.

## 12. Resource Awareness

Use time, memory, I/O, concurrency, external-service capacity, and operational cost in proportion to the problem.

Choose algorithms, access patterns, and concurrency models that match expected data sizes and loads. Do not optimize speculatively, and do not accept obvious or unbounded inefficiency. Justify significant optimizations with measurement or realistic estimates.

## 13. Consistency

Apply the same solution to problems with equivalent constraints, ownership, and lifecycle.

Follow established local conventions unless doing so would preserve a defect, violate a higher-priority principle, or materially worsen the requested design. Prefer local consistency over repository-wide uniformity when subsystems intentionally have different architectures.

## 14. Diagnosability and Verifiability

Make invalid states, failures, and violated assumptions easy to detect, localize, reproduce, and verify.

Surface failures close to their cause, preserve actionable context, and design boundaries so behavior can be inspected and verified without relying on unrelated parts of the system.
