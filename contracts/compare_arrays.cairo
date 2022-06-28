%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@external
func compare_arrays{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(
        a_len : felt, a : felt*, b_len : felt, b : felt*
    ) -> ():
    assert a_len = b_len
    
    if a_len == 0:
        return ()
    end

    assert a_len[0] = b_len[0]

    compare_arrays(a_len=a_len - 1, a=a+1, b_len=b_len - 1, b=b+1)
    return ()
end