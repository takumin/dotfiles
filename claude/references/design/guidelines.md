# Design Guidelines

These guidelines operationalize the design principles.

Apply them in context.
When guidelines conflict, follow the priority order defined in the design principles.

These guidelines are technology- and context-independent.
Guidance that presupposes a specific platform or system context — such as CLI tools, GUI applications, web frontends, web backends, or distributed services — is intentionally excluded; such guidance may be defined separately per context when needed.

## Correctness

* Identify the required behavior, invariants, affected contracts, and authoritative state before changing the implementation.
* Handle relevant success, failure, boundary, and concurrency cases explicitly.
* Preserve existing observable behavior unless the requirement explicitly changes it.
* Do not suppress, ignore, or convert failures into successful results unless that behavior is part of the defined contract.
* Keep error handling consistent with the semantics of the operation and the expectations of its callers.
* Define transaction and atomicity boundaries explicitly.
* Enforce critical invariants at the authoritative boundary, including storage constraints where appropriate.
* Handle concurrent updates explicitly; do not rely on unchecked read-modify-write behavior when concurrent modification is possible.
* Do not report success before all state required by the operation's contract is durable.
* Preserve data meaning and integrity across schema, format, serialization, and representation changes.
* Define the behavior of partial success when an operation can complete only some of its intended effects.
* Do not rely exclusively on existing tests as evidence that the implementation satisfies the requirement.

## Security by Default

* Validate untrusted input when it crosses a trust boundary and before it is used in a security-sensitive or invariant-sensitive operation.
* Treat data retrieved from storage or internal services as untrusted when its integrity or provenance is not guaranteed.
* Enforce authentication and authorization at the boundary where protected operations are exposed.
* Fail closed when an authorization or security decision cannot be completed reliably.
* Grant each component, process, dependency, and internal unit only the access it requires.
* Do not hard-code credentials, tokens, private keys, or other secrets.
* Do not expose sensitive data through logs, errors, metrics, traces, generated artifacts, or test fixtures.
* Minimize the collection, propagation, retention, and exposure of sensitive data.
* Use secure defaults for transport, storage, permissions, and cryptographic operations.
* Use established cryptographic libraries and approved algorithms; do not design custom cryptographic protocols.
* Use parameterized and context-appropriate APIs, escaping, or encoding to prevent injection.
* Do not disable certificate validation, authorization checks, input validation, integrity checks, or other security controls to make development or testing easier.
* Make security-sensitive decisions explicit and reviewable.
* Do not rely on obscurity, client-side enforcement, or caller goodwill as a security boundary.

## Compatibility and Contract Evolution

* Identify affected consumers and compatibility surfaces before changing a contract.
* Treat public APIs, internal cross-component APIs, persisted data, messages, events, configuration, command-line interfaces, error behavior, and operational expectations as compatibility surfaces where applicable.
* Prefer additive changes when they satisfy the requirement without preserving a defect.
* Do not silently change the meaning of an existing field, value, status, event, error, configuration key, or default.
* Preserve serialization formats, field identifiers, nullability, ordering guarantees, and error semantics when consumers may depend on them.
* Do not reuse deprecated identifiers or values for a different meaning.
* Define the migration path when changing a contract.
* Define deprecation conditions, communication expectations, compatibility windows, and removal criteria explicitly.
* Keep compatibility mechanisms temporary when they no longer serve a supported consumer, and remove them through an explicit migration process.
* When compatibility cannot be preserved, make the breaking impact explicit rather than hiding it behind implementation details.

## Fault Tolerance

* Set explicit timeouts or deadlines on network calls and other external or potentially blocking operations.
* Propagate deadlines and cancellation across dependent operations where supported.
* Stop unnecessary downstream work when the parent operation is cancelled or can no longer complete successfully.
* Distinguish transient failures from permanent failures before retrying.
* Retry only operations that are idempotent or otherwise protected against duplicate effects.
* Bound retry attempts, total retry duration, and retry concurrency.
* Use backoff and jitter where concurrent retries could amplify load.
* Make operations idempotent when retries, duplicate delivery, or repeated execution are expected.
* When an operation is intentionally non-idempotent, make that behavior explicit and provide duplicate protection where required.
* Define behavior for partial failure explicitly — complete, roll back, compensate, reconcile, or degrade; do not leave state silently half-updated.
* When durable state changes and external side effects cannot be committed atomically, define the consistency, deduplication, and recovery strategy explicitly.
* When an operation cannot complete, fail into a defined and recoverable state.
* Bound concurrency and queued work at external and resource-constrained boundaries.
* Do not allow queues, retries, caches, or recovery loops to grow without a defined bound.
* Avoid fallback behavior that silently changes security, correctness, or data-integrity guarantees.
* Avoid recovery mechanisms that can amplify an upstream or downstream failure.
* Preserve enough information to reconcile operations whose final outcome is uncertain.

## Simplicity

* Prefer eliminating unnecessary code, state, configuration, dependencies, or concepts over adding new mechanisms.
* Build for known requirements rather than imagined future requirements.
* When two solutions are equally correct and maintainable, choose the one with fewer moving parts.
* Avoid configurable behavior unless a supported use case requires variation.
* Keep the implementation no more flexible than current requirements and demonstrated risks justify.
* Prefer direct and readable control flow over clever, compressed, or indirect implementations.
* Do not introduce a framework, pattern, service, queue, cache, or general-purpose mechanism to solve a local problem unless its additional cost is justified.
* Do not add a new external dependency when the standard library or an existing dependency adequately satisfies the correctness, security, maintenance, and operational requirements.
* Remove obsolete paths and mechanisms when their supported use case no longer exists and compatibility requirements permit removal.
* Do not preserve accidental complexity solely because it already exists.

## Separation of Concerns

* Separate responsibilities that change for different business or technical reasons.
* Do not mix domain decisions, I/O, persistence, transport, presentation, configuration, and orchestration without a clear reason.
* Separate policy from mechanism.
* Keep pure computation separate from side effects where practical.
* Keep orchestration distinct from the units that perform individual operations.
* Compose small, focused units rather than building large multi-purpose units.
* Do not split responsibilities that are tightly coupled in practice and consistently change together.
* Place behavior with the component that owns the relevant invariants or lifecycle; this need not be the physical data representation or persistence model.
* Keep resource ownership and cleanup responsibility in the same clearly defined lifecycle.
* Avoid context objects that obscure unrelated dependencies.
* A cohesive request, transaction, security, cancellation, or tracing context is acceptable when it represents a real boundary.
* Do not require unrelated components to change because one responsibility or policy changes.
* Keep translation between domain, transport, persistence, and external representations at the boundary that owns the translation.

## Abstraction

* Name abstractions after the intent, capability, policy, or domain concept they represent, not the mechanism currently used to implement them.
* Give each abstraction a clear owner and responsibility.
* Expose the minimum interface necessary to satisfy callers.
* Hide implementation details that callers do not need to know.
* Keep implementation-specific choices behind the boundary that owns them.
* Do not leak external library types, persistence schemas, transport formats, framework objects, or infrastructure concerns across architectural boundaries without a deliberate reason.
* Do not add a layer of indirection unless it solves a demonstrated problem.
* Introduce a project-owned interface around an external dependency only when it:
  * isolates domain logic;
  * protects a meaningful architectural boundary;
  * prevents external API leakage;
  * provides a required substitution point;
  * centralizes translation, policy, or error handling;
  * addresses demonstrated volatility; or
  * materially improves verifiability without obscuring the design.
* Do not create a project-owned interface solely because an implementation exists or might be replaced someday.
* A single implementation may still justify an interface when it protects a meaningful architectural or contract boundary.
* Prefer a concrete implementation until an abstraction has a clear responsibility and a demonstrated consumer or boundary need.
* Do not generalize from a single case without evidence that the abstraction represents a stable concept.
* Do not unify implementations merely because their current code shape is similar.
* Keep abstractions smaller, more intentional, and more stable than the implementations behind them.
* Avoid interfaces that expose every capability of the implementation rather than the needs of the caller.
* Remove or collapse abstractions that no longer reduce complexity, express intent, or protect a meaningful boundary.

## Explicit over Implicit

* Declare dependencies at module, component, or operation boundaries.
* Make side effects visible through interfaces, signatures, names, command boundaries, or clearly documented lifecycle rules.
* Pass behavior-affecting inputs explicitly rather than reading them from ambient global state.
* Make behavior-affecting defaults visible and documented.
* Prefer explicit configuration over convention-based behavior when the convention would be surprising, security-sensitive, or difficult to trace.
* Keep configuration schemas validated, discoverable, and owned by a defined component.
* Make required configuration distinguishable from optional configuration.
* Make error paths and error categories explicit where callers must react differently.
* Do not represent failure using a value that is indistinguishable from a valid successful result.
* Define retry semantics at boundaries where callers must decide whether to retry, compensate, or reject.
* Preserve the original cause and relevant operation context when translating errors across boundaries.
* Avoid control flow that depends on initialization order, import order, global mutation, undocumented runtime behavior, or arbitrary timing.
* Document necessary implicit framework behavior at the point where the project depends on it.
* Do not hide important behavior in annotations, reflection, code generation, hooks, interceptors, or middleware without making the dependency discoverable.
* Make ownership, lifecycle, and cleanup obligations explicit for resources and background operations.

## Single Source of Truth

* Maintain one authoritative definition for each shared semantic business rule, fact, schema, or configuration decision within its ownership boundary.
* Make the owner of authoritative data explicit.
* Derive values from authoritative data instead of copying them manually.
* Generate repeated representations where practical rather than maintaining synchronized copies by hand.
* Treat caches, indexes, generated files, read models, search documents, and replicas as derived representations.
* Define how derived representations are produced, invalidated, rebuilt, or reconciled.
* Do not assume a cache, index, replica, or generated artifact is authoritative unless the design explicitly assigns it that role.
* Consolidate duplicated knowledge when independent copies could become inconsistent.
* Prefer automated synchronization when duplication is necessary.
* Do not merge similar code or data until confirming that it represents the same semantic concept and changes for the same reason.
* Do not centralize values that are coincidentally equal but owned by different responsibilities.
* Allow independent bounded contexts to own separate representations when their semantics, lifecycle, or authority differ.
* Make ownership transfers and synchronization direction explicit when authority changes.

## Design for Change

* Isolate decisions that are known to vary or that carry a significant cost or risk of change.
* At architectural boundaries and required substitution points, depend on stable contracts rather than volatile implementations.
* Minimize coupling so that a change affects only modules that depend on the changed responsibility or contract.
* Prefer reversible decisions when the cost difference is reasonable.
* Defer irreversible decisions until the available information justifies them.
* Design optional components so they can be removed without changes to unrelated parts.
* Keep policy choices separate from low-level mechanisms when policy is expected to vary.
* Avoid exposing volatile implementation details through stable boundaries.
* Do not add extension points without a demonstrated variation, consumer, or risk.
* When changing a contract is necessary, make the migration path and compatibility impact explicit.
* Choose data and message representations that can evolve according to the required compatibility strategy.
* Keep temporary migration mechanisms isolated and removable.
* Do not introduce permanent complexity solely to avoid a low-cost and unlikely future change.

## Predictability

* Produce the same observable result given the same controlled input and state.
* Make sources of time, randomness, concurrency, environment, locale, external state, and behavior-affecting configuration explicit.
* Inject or control nondeterministic inputs when deterministic behavior is required for reproducibility or verification.
* Minimize shared mutable state.
* When state must be shared across threads or processes, make ownership, visibility, synchronization, and consistency guarantees explicit.
* Coordinate asynchronous operations through explicit synchronization, events, or completion signals rather than timing assumptions or arbitrary delays.
* Define ordering explicitly when correctness depends on it.
* Make the order of independent operations irrelevant to the final result where practical.
* Avoid relying on unspecified iteration, scheduling, serialization, or dependency behavior.
* Make the versions of behavior-affecting dependencies and execution environments reproducible where required.
* Supply, record, or derive all behavior-affecting configuration explicitly.
* Define behavior for clock changes, time zones, locale differences, and numeric precision when they can affect observable results.
* Prefer deterministic conflict resolution when repeated or concurrent processing can produce competing results.

## Resource Awareness

* Choose algorithms and data structures appropriate to the expected data size, access pattern, and worst-case input.
* Do not accept worst-case behavior that is incompatible with expected operational limits.
* Process large or unbounded data incrementally — stream, paginate, window, or batch — instead of loading it into memory at once.
* Avoid repeated I/O inside loops when a batch or set-based operation is available, including N+1 query patterns.
* Bound caches, queues, buffers, retries, concurrency, and retained history.
* Treat unbounded growth as a defect unless the system is explicitly designed around an external bound.
* Bound concurrent access to constrained resources such as databases, services, threads, processes, sockets, and file descriptors.
* Release resources such as connections, file handles, temporary files, memory mappings, and locks deterministically.
* Avoid holding scarce resources while performing unrelated or potentially slow operations.
* Consider latency, request amplification, data transfer, storage growth, and external-service cost as resources.
* Avoid full scans, excessive serialization, unnecessary copies, and repeated remote calls when a simpler bounded access pattern is available.
* Do not sacrifice clarity for speculative micro-optimization.
* Justify significant optimizations using measurement, profiling, capacity requirements, or realistic estimates.
* Preserve correctness and security when introducing caching, batching, parallelism, or other performance mechanisms.

## Consistency

* Use established local patterns consistently for equivalent problems within the same ownership and lifecycle boundary.
* Keep naming, error handling, dependency management, configuration, resource ownership, and architectural patterns predictable within the same boundary.
* Apply the same pattern only when the constraints, semantics, ownership, and lifecycle are materially equivalent.
* Prefer local consistency over repository-wide uniformity when different subsystems intentionally have different architectures.
* Do not copy an existing pattern when it would preserve a defect or violate a higher-priority principle.
* Do not force uniformity between bounded contexts that have different requirements.
* Keep intentional divergence narrow.
* Document the reason for intentional divergence at the point where it occurs.
* Prefer extending an established suitable pattern over introducing a competing pattern for the same purpose.
* Remove obsolete competing patterns when migration and compatibility requirements permit it.

## Diagnosability and Verifiability

* Check preconditions and invariants at the earliest responsible point.
* Validation of untrusted input belongs at the relevant trust boundary under Security by Default.
* Fail fast when continuing would violate an invariant, corrupt state, hide the cause, or produce an invalid result.
* Do not fail early when the operation's contract requires aggregation, compensation, degradation, or continued processing.
* Surface failures close to their cause.
* Preserve enough context to identify the failed operation, relevant input category, dependency, and actionable cause without exposing sensitive information.
* Distinguish configuration errors, dependency failures, invalid input, resource exhaustion, compatibility failures, and implementation defects where the distinction affects diagnosis or recovery.
* Preserve causal chains when wrapping or translating errors.
* Record significant operations and external interactions at system boundaries with enough context to trace behavior after the fact.
* Avoid logging the same failure repeatedly at multiple layers unless each layer adds distinct operational context.
* Design units and boundaries so behavior can be verified independently of unrelated infrastructure.
* Make time, randomness, external services, and side effects controllable where independent verification requires it.
* Write code whose intent, dependencies, control flow, state changes, and error handling can be understood during review.
* Prefer failures that are actionable over generic or ambiguous failure messages.
* Ensure diagnostic mechanisms do not alter correctness, security, timing-sensitive behavior, or resource bounds materially.
