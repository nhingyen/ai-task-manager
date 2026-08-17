# MVP Functional Requirements

## Scope

These requirements define observable product behavior for the single-user,
local-first MVP described in `docs/PRODUCT.md`. They do not define UI layouts,
storage schemas, persistence libraries, repository implementations, or state
management implementations.

## Task definition

Each task contains exactly these MVP fields:

- `id`: a unique identifier;
- `title`: required task text;
- `description`: optional additional detail;
- `isCompleted`: completion state; and
- `createdAt`: task creation timestamp.

No due date, priority, tag, subtask, or other task field is part of the MVP.

## Functional requirements

### FR-001 — View tasks

#### Description

The user can view the current task list and distinguish completed tasks from
incomplete tasks.

#### Business rules

- The all-tasks view includes both completed and incomplete tasks.
- Tasks are ordered by `createdAt` descending, with the newest task first.
- Ordering between tasks with equal `createdAt` values is unspecified for the
  MVP.
- The task list uses only the approved task fields.
- An empty task list provides an understandable empty state.

#### Acceptance criteria

- Given stored tasks with different `createdAt` values, when the user views all
  tasks, then the newest task appears before older tasks.
- Given completed and incomplete tasks, when the user views all tasks, then
  both completion states are represented.
- Given no tasks, when the user views the task list, then an understandable
  empty state is provided.
- Given tasks with equal `createdAt` values, when the user views them, then the
  product does not require a particular relative order.

### FR-002 — Create a task

#### Description

The user can create a task with a required title and optional description.

#### Business rules

- A created task has a unique `id` and a `createdAt` timestamp.
- The title must not be empty or whitespace-only.
- The description is optional.
- A new task starts incomplete (`isCompleted` is false).
- A successfully created task is included in the task list and is ordered by
  its creation timestamp.
- A rejected creation does not save a task.
- If local persistence of the change fails, the user receives clear failure
  feedback and the application must not indicate that the task was saved.

#### Acceptance criteria

- Given a non-blank title, when the user creates a task, then one new
  incomplete task is added with a unique ID and creation timestamp.
- Given an optional description, when the user creates a task, then the task
  retains that description.
- Given an empty or whitespace-only title, when the user attempts to create a
  task, then creation is rejected, the entered values remain available for
  correction, and clear validation feedback is provided.
- Given a persistence failure during creation, when the operation completes,
  then the user receives clear failure feedback and the task is not reported as
  saved.

### FR-003 — Edit a task

#### Description

The user can edit the title and optional description of an existing task.

#### Business rules

- Editing targets an existing task by its unique `id`.
- The title must not be empty or whitespace-only after editing.
- The description may be added, changed, or removed.
- Editing preserves the task's existing `createdAt` value.
- Editing does not change `isCompleted`.
- A rejected edit does not replace the last valid saved task.
- If local persistence of the change fails, the user receives clear failure
  feedback and the application must not indicate that the edit was saved.

#### Acceptance criteria

- Given an existing task, when the user saves a valid title or description
  change, then the task is updated and its `createdAt` value is unchanged.
- Given an existing task with a description, when the user removes the
  description and saves, then the task is updated with no description.
- Given an existing completed or incomplete task, when the user edits it, then
  its completion state is unchanged.
- Given an empty or whitespace-only edited title, when the user attempts to
  save, then the edit is rejected, the entered values remain available for
  correction, and clear validation feedback is provided.
- Given a persistence failure during editing, when the operation completes,
  then the user receives clear failure feedback and the edit is not reported as
  saved.

### FR-004 — Delete a task

#### Description

The user can delete an existing task after explicitly confirming the deletion.

#### Business rules

- Deletion targets an existing task by its unique `id`.
- Explicit confirmation is required before deletion.
- Cancelling or declining confirmation does not delete the task.
- Confirmed deletion removes the task from the current task list.
- A deleted task does not reappear after the application is reopened.
- If local persistence of the deletion fails, the user receives clear failure
  feedback and the application must not indicate that the deletion was saved.

#### Acceptance criteria

- Given an existing task, when the user requests deletion, then deletion does
  not occur until explicit confirmation is provided.
- Given a pending deletion, when the user declines or cancels confirmation,
  then the task remains available.
- Given a pending deletion, when the user confirms, then the task is removed
  from the task list.
- Given a confirmed deletion that is persisted successfully, when the user
  reopens the application, then the deleted task is not present.
- Given a persistence failure during deletion, when the operation completes,
  then the user receives clear failure feedback and the deletion is not
  reported as saved.

### FR-005 — Mark a task complete or incomplete

#### Description

The user can change an existing task between incomplete and complete.

#### Business rules

- Completion is represented by `isCompleted`.
- The transition from incomplete to complete is supported.
- The transition from complete to incomplete is supported.
- Changing completion preserves `createdAt`.
- Completion changes are subject to the active status filter immediately.
- If local persistence of the change fails, the user receives clear failure
  feedback and the application must not indicate that the change was saved.

#### Acceptance criteria

- Given an incomplete task, when the user marks it complete, then its
  `isCompleted` value becomes true and its `createdAt` value is unchanged.
- Given a completed task, when the user marks it incomplete, then its
  `isCompleted` value becomes false and its `createdAt` value is unchanged.
- Given a successful completion change, when the user reopens the application,
  then the latest completion state is retained.
- Given a persistence failure during a completion change, when the operation
  completes, then the user receives clear failure feedback and the change is
  not reported as saved.

### FR-006 — Filter tasks by status

#### Description

The user can filter the task list by completion status.

#### Business rules

- The available filters are All tasks, Incomplete tasks, and Completed tasks.
- The default filter is All tasks.
- The All tasks filter includes both completion states.
- The Incomplete tasks filter includes only tasks where `isCompleted` is
  false.
- The Completed tasks filter includes only tasks where `isCompleted` is true.
- Matching tasks retain `createdAt` descending order.
- Equal-`createdAt` ordering remains unspecified.
- The active filter is reapplied immediately after a completion state change.
- A task that no longer matches the active filter no longer appears in that
  filtered view.
- Filter selection is not persisted between application sessions.
- The application starts with the All tasks filter after reopening.
- A filter with no matching tasks provides an understandable empty state.

#### Acceptance criteria

- Given the application starts or is reopened, then the All tasks filter is
  active.
- Given completed and incomplete tasks, when the user selects Incomplete
  tasks, then only incomplete tasks are shown.
- Given completed and incomplete tasks, when the user selects Completed tasks,
  then only completed tasks are shown.
- Given a selected filter with matching tasks, then matching tasks appear in
  `createdAt` descending order.
- Given a selected filter with no matches, then an understandable empty state
  is provided.
- Given the Incomplete tasks filter is active, when an incomplete task is
  marked complete successfully, then it no longer appears in that view.
- Given the Completed tasks filter is active, when a completed task is marked
  incomplete successfully, then it no longer appears in that view.
- Given a selected non-default filter, when the application is reopened, then
  the filter is reset to All tasks.

### FR-007 — Persist tasks locally

#### Description

The application preserves task data locally between sessions on the same
device, without requiring authentication, network access, or cloud services.

#### Business rules

- Created, edited, completed, uncompleted, and deleted task changes are
  persisted locally.
- Persistence covers the approved task fields.
- Successfully persisted changes remain available after the application is
  closed and reopened.
- Filter selection is not persisted.
- If a change cannot be persisted, the user receives clear failure feedback and
  the application must not falsely indicate that the change was saved.
- If stored task data cannot be loaded, the application reports the failure and
  must not silently discard or overwrite the existing stored data.
- Detailed recovery behavior for unreadable stored data is outside this MVP
  requirements document.

#### Acceptance criteria

- Given a task is created, edited, completed, uncompleted, or deleted
  successfully, when the application is closed and reopened, then the task
  data reflects the latest successfully persisted result.
- Given a persistence failure during a task change, then the user receives
  clear failure feedback and the application does not report the change as
  saved.
- Given stored task data cannot be loaded, when the application starts, then it
  reports the load failure and does not silently discard or overwrite the
  stored data.
- Given the application is reopened after a prior session, then it starts with
  the All tasks filter rather than restoring the previous filter selection.

## MVP non-functional boundaries

- The product is single-user and local-first.
- The MVP requires persistence between normal application close and reopen
  sessions on the same device.
- These requirements do not select a persistence technology, define a storage
  schema, or prescribe implementation architecture.
- Authentication, backend services, cloud synchronization, notifications,
  collaboration, and AI functionality are outside the MVP.
