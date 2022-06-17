%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func owner() -> (address : felt):
end

@constructor
func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(address : felt)->():
    owner.write(value=address)
    return ()
end

@view
func get_owner{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (owner : felt):
    let (res) = owner.read()
    return (owner=res)
end
