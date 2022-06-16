%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_nn

@storage_var
func user_balance(user : felt) -> (balance : felt):
end

@external
func increase_balance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(amount : felt) -> ():
    with_attr error_message("Amount provided is not positive. Got: {amount}."):
        assert_nn(amount)
    end

    let (user) = get_caller_address()

    let (res) = user_balance.read(user=user)
    user_balance.write(user=user, value=res + amount)
    return ()
end

@view
func get_balance{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(user : felt) -> (balance : felt):
    let (res) = user_balance.read(user=user)
    return (balance=res)
end