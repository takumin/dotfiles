# Design Guidelines

## Separation of Concerns

- Give each unit exactly one reason to change.
- Do not mix I/O, logic, and configuration in the same place.
- Separate policy from mechanism.
- Compose small focused units rather than building large multi-purpose ones.
- Do not split what changes together; co-locate things that are coupled in practice.
- Grant each unit access only to what it needs; do not pass more context than required.

## Abstraction

- Name things after what they do, not how they work.
- Expose intent through interfaces; hide implementation behind them.
- Do not leak internal structure across boundaries.
- Define your own interface before wrapping external dependencies.

## Explicit over Implicit

- Declare all dependencies at the boundary.
- Make side effects visible in signatures or names.
- Prefer data-driven configuration over convention-based magic.
- Document every default; make every default overridable.
- Make error paths explicit; do not hide failures in normal control flow.

## Fast Feedback

- Fail fast: validate at the boundary, surface errors immediately.
- Write tests that run in seconds, not minutes.
- Make every step in build, test, and deploy observable.
- Prefer incremental checks over end-to-end-only validation.
- Write code that can be read and reviewed without running it.

## Design for Change

- Depend on abstractions, not concrete implementations.
- Isolate volatile decisions behind stable interfaces.
- Keep coupling low: a change in one module must not cascade.
- Prefer reversible decisions; defer irreversible ones as long as practical.
- Design units so they can be removed without requiring changes to unrelated parts.

## Simplicity

- Do not add a layer of indirection unless it solves a problem that exists today.
- Prefer removing code over adding code to solve a problem.
- When two solutions are equally correct, choose the one with fewer moving parts.
- Resist speculative generality: build for known requirements, not imagined ones.

## Consistency

- Follow established conventions in the codebase before introducing new ones.
- Apply the same pattern to the same category of problem throughout a project.
- Make structural choices predictable across boundaries.
- When breaking consistency is justified, document the reason at the point of divergence.
