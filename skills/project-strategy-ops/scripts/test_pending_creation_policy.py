#!/usr/bin/env python3
"""Regression fixture for the temporary client-thread lifecycle."""


def next_action(state, event):
    if state == "pending" and event in {"bounded_wait_expired", "missing_from_list"}:
        return "remain_pending"
    if state == "pending" and event in {"retry_create", "switch_environment"}:
        return "reject_duplicate"
    if state == "pending" and event == "real_thread_materialized":
        return ("pin", "move_to_strategy_block", "sidebar_readback")
    if state == "terminal_failure" and event == "placeholder_not_cancellable":
        return "report_ui_cleanup_blocker"
    raise AssertionError(f"Unhandled transition: {state=}, {event=}")


def main():
    pending_key = (
        "project",
        "[프로젝트실행] 작업명",
        "purpose",
        "read_only",
        "source_scope",
    )
    assert len(pending_key) == 5
    assert next_action("pending", "bounded_wait_expired") == "remain_pending"
    assert next_action("pending", "missing_from_list") == "remain_pending"
    assert next_action("pending", "retry_create") == "reject_duplicate"
    assert next_action("pending", "switch_environment") == "reject_duplicate"
    assert next_action("pending", "real_thread_materialized") == (
        "pin",
        "move_to_strategy_block",
        "sidebar_readback",
    )
    assert (
        next_action("terminal_failure", "placeholder_not_cancellable")
        == "report_ui_cleanup_blocker"
    )
    print("pending creation regression: PASS")


if __name__ == "__main__":
    main()
