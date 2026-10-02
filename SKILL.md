---
name: kgateway-development
description: >
  Implement or review code changes in kgateway-dev/kgateway and solo-io/gloo-gateway, including
  KRT collections, policy attachment, backend and route indexes, translation, Istio integration,
  and generated data-plane configuration. Use for feature implementation, bug fixes,
  implementation-plan execution, stabilization, and code review. Do not use for general product
  support or standalone reproducer creation.
---

# Kgateway Development

Implement and review kgateway changes at the behavioral boundary where users and downstream
components observe them. Follow repository-local instructions and the approved design and
implementation plan. Preserve OSS and enterprise module boundaries.

## Establish Scope

Before editing:

1. Identify whether the change belongs in `kgateway-dev/kgateway`, `solo-io/gloo-gateway`, or
   both. Check both layers before concluding that a capability or configuration hook is absent.
2. Read the relevant design and implementation plan and stop if the proposed work conflicts with
   either.
3. Inspect the authoritative API, CRD, or schema for configured behavior. A partial source trace
   is not proof of a product limitation.
4. Identify the production path from user input to the observable result, including every index,
   alias, fallback, merge, precedence rule, translation stage, and generated resource it crosses.

## Test at the Behavioral Boundary

Add a regression test at the highest practical boundary where the bug or feature is observable.
Helper-level tests are supplementary and do not replace this test.

Examples:
- Policy attachment: exercise the real `PolicyIndex` and `BackendIndex` path.
- Backend references: exercise backend or route resolution.
- KRT changes: exercise the consuming collection or index, not only its transform function.
- Translation changes: inspect the resulting IR or xDS resource.
- Status changes: exercise reconciliation and assert the resulting conditions.

Use test-driven development: demonstrate that the regression test fails for the expected reason
without the implementation, then passes with it. Also run focused helper tests and the complete
affected package suite using repository-approved commands.

## Alias, Index, and Lookup Changes

When adding or changing aliases, index keys, projections, selectors, target references, or lookup
fallbacks:

1. Trace every consumer of the changed output.
2. Determine whether each consumer appends, merges, deduplicates, applies precedence, or rejects
   duplicate and ambiguous results.
3. Test the applicable cases:
   - name-based and selector-based lookup
   - intended namespace attachment or resolution
   - rejection from unrelated namespaces
   - global-policy-namespace fallback
   - duplicate discovery, attachment, and generated configuration
   - empty or malformed label values
   - projected namespace equal to source namespace
   - single-key and multi-key inputs, including multiple hostnames
   - omitted and explicitly supplied reference namespaces
4. If multiple keys can discover the same logical policy or backend, assert exactly one logical
   result unless multiplicity is explicitly intended.

Do not infer route-resolution behavior from the default namespace alone. Check whether an
explicit namespace overrides defaults and whether `ReferenceGrant` validation applies.

## Compatibility and Workarounds

Turn material compatibility claims into tests when practical. Test every path described by the
design or PR as unchanged, preserved, still supported, backwards compatible, or unaffected.

Include existing documented or customer-used workarounds in the compatibility matrix. A fix can
activate previously inert configuration or cause the workaround and new path to attach
simultaneously. Test precedence and duplicate handling when both are present.

## Control-Plane and Data-Plane Effects

For changes that can affect generated configuration, state and verify:
- generated object cardinality as a function of user input
- worst realistic configuration growth
- per-request cost
- xDS churn and blast radius
- metric and observability effects
- activation of previously inert configuration

For apparently control-plane-only structures such as aliases or indexes, inspect downstream
consumers to ensure they do not multiply policies, merges, or generated resources.

## Review and Handoff

Before completion:
1. Reconcile the implementation against every design and plan requirement.
2. Run the focused regression test, complete affected package suite, formatting or lint checks,
   and compilation check required by the repository.
3. Inspect the final diff and worktree for generated or unrelated changes.
4. Verify the repository's changelog mechanism and prepare the required release-note content.
5. Call out untested behavior, environmental blockers, dormant-configuration activation, and
   follow-up work explicitly.
