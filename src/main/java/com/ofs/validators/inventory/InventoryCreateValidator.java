package com.ofs.validators.inventory;

import com.ofs.model.Inventory;
import com.ofs.server.errors.BadRequestException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.validations.InventoryCreateValidation;
import com.ofs.validators.Validator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class InventoryCreateValidator implements Validator<Inventory> {

    private final List<InventoryCreateValidation> VALIDATIONS = new ArrayList<>();

    @Autowired
    public InventoryCreateValidator(List<InventoryCreateValidation> validations) {
        validations.forEach(validation ->
                VALIDATIONS.add(validation)
        );
    }

    @Override
    public void validate(Inventory inventory, OFSErrors errors) throws Exception {
        for (InventoryCreateValidation validation : VALIDATIONS) {
            validation.validate(inventory, errors);
        }

        if(!errors.isEmpty()) {
            throw new BadRequestException(errors);
        }
    }

    @Override
    public void validate(ChangeSet changeSet, Inventory inventory, OFSErrors errors) throws Exception {
        for (InventoryCreateValidation validation : VALIDATIONS) {
            validation.validate(changeSet, inventory, errors);
        }

        if(!errors.isEmpty()) {
            throw new BadRequestException(errors);
        }
    }
}
