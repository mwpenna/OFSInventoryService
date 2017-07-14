package com.ofs.validations.inventory;

import com.ofs.model.Inventory;
import com.ofs.repository.InventoryRepository;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.validations.InventoryCreateValidation;
import com.ofs.validations.InventoryUpdateValidation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

@Component
public class ValidateInventoryNameDNE implements InventoryUpdateValidation, InventoryCreateValidation {

    @Autowired
    private InventoryRepository inventoryRepository;

    @Override
    public void validate(Inventory inventory, OFSErrors errors) throws Exception {
        Optional<List<Inventory>> inventoryListOptional = inventoryRepository.getInventoryByName(inventory.getCompanyId(), inventory.getName());

        if(inventoryListOptional.isPresent()) {
            List<Inventory> inventoryList = inventoryListOptional.get();

            if(!inventoryList.isEmpty()) {
                errors.rejectValue("inventory.name.exists", "Invalid inventory name. Inventory item already exists with that name.");
            }
        }
    }

    @Override
    public void validate(ChangeSet changeSet, Inventory inventory, OFSErrors errors) throws Exception {
        if(changeSet.contains("name")) {
            validate(inventory, errors);
        }
    }
}
