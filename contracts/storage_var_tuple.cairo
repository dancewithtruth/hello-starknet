%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func range(user : felt) -> (res : (felt, felt)):
end

@external
func extend_range{syscall_ptr : felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(user : felt) -> ():
    let (res) = range.read(user=user)
    let new_range = (res[0] - 1, res[1] + 1)
    range.write(user=user, value=new_range)
    return ()
end
