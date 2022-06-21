%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

struct User:
    member first_name : felt
    member last_name : felt

@storage_var
func user_voted(user : User) -> (res : felt):
end

@external
func vote{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(user : User) -> ():
    user_voted.write(user=user, value=1)
    return ()
end