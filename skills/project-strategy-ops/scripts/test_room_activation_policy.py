#!/usr/bin/env python3
"""Regression fixture for strategy and execution room activation evidence."""


REQUIRED_CAPABILITIES = {
    "search",
    "create_or_select",
    "rename",
    "pin",
    "reorder",
    "deliver_instruction",
    "readback",
}
SUBAGENT_SOURCES = {"subagent", "subAgent", "subAgentThreadSpawn", "spawn_agent"}


def capability_status(available):
    missing = REQUIRED_CAPABILITIES - set(available)
    return "ready" if not missing else "organization_blocker"


def room_operation_action(available):
    if capability_status(available) == "ready":
        return "use_room_tools"
    return "report_blocker"


def strategy_status(*, top_level, real_thread_id, title_readback, pin_readback):
    if all((top_level, real_thread_id, title_readback, pin_readback)):
        return "organized"
    return "setup_incomplete"


def execution_status(
    *,
    source,
    top_level,
    user_visible,
    real_thread_id,
    instruction_delivered,
    title_readback,
    pin_readback,
    contiguous_sidebar_readback,
):
    if source in SUBAGENT_SOURCES:
        return "not_execution_room"
    if not real_thread_id:
        return "remain_pending"
    if not top_level or not user_visible:
        return "inconclusive"
    if not all(
        (
            instruction_delivered,
            title_readback,
            pin_readback,
            contiguous_sidebar_readback,
        )
    ):
        return "inconclusive"
    return "active"


def task_sync_allowed(status):
    return status == "active"


def main():
    assert capability_status(REQUIRED_CAPABILITIES) == "ready"
    assert capability_status({"create_or_select", "readback"}) == "organization_blocker"
    assert room_operation_action(REQUIRED_CAPABILITIES) == "use_room_tools"
    assert room_operation_action({"create_or_select", "readback"}) == "report_blocker"
    assert (
        strategy_status(
            top_level=True,
            real_thread_id=True,
            title_readback=True,
            pin_readback=False,
        )
        == "setup_incomplete"
    )
    assert (
        execution_status(
            source="spawn_agent",
            top_level=False,
            user_visible=False,
            real_thread_id=True,
            instruction_delivered=True,
            title_readback=False,
            pin_readback=False,
            contiguous_sidebar_readback=False,
        )
        == "not_execution_room"
    )
    navigate_ack_only = execution_status(
        source="user",
        top_level=True,
        user_visible=True,
        real_thread_id=True,
        instruction_delivered=False,
        title_readback=False,
        pin_readback=False,
        contiguous_sidebar_readback=False,
    )
    assert navigate_ack_only == "inconclusive"
    assert not task_sync_allowed(navigate_ack_only)
    real_id_without_sidebar = execution_status(
        source="user",
        top_level=True,
        user_visible=True,
        real_thread_id=True,
        instruction_delivered=True,
        title_readback=True,
        pin_readback=True,
        contiguous_sidebar_readback=False,
    )
    assert real_id_without_sidebar == "inconclusive"
    assert not task_sync_allowed(real_id_without_sidebar)
    active = execution_status(
        source="user",
        top_level=True,
        user_visible=True,
        real_thread_id=True,
        instruction_delivered=True,
        title_readback=True,
        pin_readback=True,
        contiguous_sidebar_readback=True,
    )
    assert active == "active"
    assert task_sync_allowed(active)
    print("room activation regression: PASS")


if __name__ == "__main__":
    main()
