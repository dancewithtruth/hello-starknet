%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_nn
from starkware.starknet.common.messages import send_message_to_l1
from starkware.starknet.common.syscalls import get_caller_address

const L1_CONTRACT_ADDRESS = 0x2Db8c2615db39a5eD8750B87aC8F217485BE11EC
const MESSAGE_WITHDRAW = 0

@storage_var
func balance(user : felt) -> (res : felt):
end

@view
func get_balance{
    syscall_ptr : felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(user : felt) -> (balance : felt):
    let (res) = balance.read(user=user)
    return (res)
end

@external
func increase_balance{
    syscall_ptr : felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(amount : felt) -> ():
    with_attr error_message("Amount provided is not positive. Got: {amount}."):
        assert_nn(amount)
    end

    let (user) = get_caller_address()

    let (res) = balance.read(user=user)
    balance.write(user=user, value=res + amount)
    return ()
end

@external
func withdraw{
    syscall_ptr : felt*,
    pedersen_ptr: HashBuiltin*,
    range_check_ptr
}(amount : felt) -> ():
    with_attr error_message("Amount provided is not positive. Got: {amount}."):
        assert_nn(amount)
    end

    let (user) = get_caller_address()

    let (res) = balance.read(user=user)
    tempvar new_balance = res - amount

    with_attr error_message("Amount requested will result in negative balance."):
        assert_nn(new_balance)
    end

    balance.write(user=user, value=new_balance)

    let (message_payload : felt*) = alloc()
    assert message_payload[0] = MESSAGE_WITHDRAW
    assert message_payload[1] = user
    assert message_payload[2] = amount
    send_message_to_l1(
        to_address=L1_CONTRACT_ADDRESS,
        payload_size=3,
        payload=message_payload,
    )

    return ()
end

@l1_handler
func deposit{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(from_address : felt, user : felt, amount : felt):
    # Make sure the message was sent by the intended L1 contract.
    assert from_address = L1_CONTRACT_ADDRESS

    # Read the current balance.
    let (res) = balance.read(user=user)

    # Compute and update the new balance.
    tempvar new_balance = res + amount
    balance.write(user, new_balance)

    return ()
end
