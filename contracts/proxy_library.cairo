%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

@contract_interface
namespace IBalanceContract:
    func library_call_increase_balance(amount : felt):
    end

    func library_call_get_balance(user : felt) -> (balance : felt):
    end
end

# Define local balance variable in our proxy contract.
@storage_var
func balance(user : felt) -> (res : felt):
end

@external
func increase_my_balance{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr
    }(
        class_hash : felt,
        amount : felt
    ):
    IBalanceContract.library_call_increase_balance(class_hash=class_hash, amount=amount)
    return ()
end