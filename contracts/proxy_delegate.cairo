%lang starknet

from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import library_call

@event
func AdminTransferred(prev_admin: felt, new_admin: felt):
end

@storage_var
func admin() -> (admin : felt):
end

@storage_var
func implementation_hash() -> (implementation_hash : felt):
end

@constructor
func constructor{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
}(initial_admin : felt, implementation_hash_ : felt):
    _set_admin(new_admin=initial_admin)
    implementation_hash.write(value=implementation_hash_)
    return ()
end

func _set_admin{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
}(new_admin : felt):
    let (prev_admin) = admin.read()
    admin.write(value=new_admin)
    AdminTransferred.emit(prev_admin=prev_admin, new_admin=new_admin)
    return ()
end

func _assert_admin{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
}():
    let (curr_admin) = admin.read()
    let (caller) = get_caller_address()
    with_attr error_message("Caller is not the admin"):
        assert curr_admin = caller
    end
    return ()
end

@external
func set_admin{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
}(new_admin : felt):
    _assert_admin()
    _set_admin(new_admin=new_admin)
    return ()
end

@external
func set_implementation_hash{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
}(new_implementation_hash : felt):
    _assert_admin()
    implementation_hash.write(value=new_implementation_hash)
    return ()
end

@external
@raw_input
@raw_output
func __default__{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr
}(selector : felt, calldata_size : felt, calldata : felt*) -> (retdata_size : felt, retdata : felt*):
    let (class_hash) = implementation_hash.read()

    let (retdata_size : felt, retdata : felt*) = library_call(
        class_hash=class_hash,
        function_selector=selector,
        calldata_size=calldata_size,
        calldata=calldata,
    )
    return (retdata_size=retdata_size, retdata=retdata)
end