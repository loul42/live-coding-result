import "Owned.sol";
import "WarehouseI.sol";

contract AppStore is Owned {
	struct Product {
		string name;
		uint price;	
	}

	mapping(uint => Product) public products;
	uint[] public ids;
	address public warehouse;

	event LogProductAdded(uint id, string name, uint price);
	event LogProductPurchased(uint id, address customer);

	function AppStore(address _warehouse) {
		warehouse = _warehouse;
	}

	function count() returns (uint length) {
		return ids.length;	
	}

	function addProduct(uint id, string name, uint price)
		fromOwner
		returns (bool successful) {
		products[id] = Product({
			name: name,
			price: price
		});
		ids.push(id);
		LogProductAdded(id, name, price);
		return true;
	}

	function buyProduct(uint id)
		returns (bool successful) {
		if (msg.value < products[id].price)	{
			throw;
		}
		if (!WarehouseI(warehouse).ship(id, msg.sender)) {
			throw;
		}
		LogProductPurchased(id, msg.sender);
		return true;
	}
}