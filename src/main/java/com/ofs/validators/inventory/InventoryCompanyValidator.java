package com.ofs.validators.inventory;

import com.ofs.server.errors.BadRequestException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.validations.InventoryCompanyValidation;
import com.ofs.validators.Validator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class InventoryCompanyValidator implements Validator<String> {

    private final List<InventoryCompanyValidation> VALIDATIONS = new ArrayList<>();

    @Autowired
    public InventoryCompanyValidator(List<InventoryCompanyValidation> validations) {
        validations.forEach(validation ->
                VALIDATIONS.add(validation)
        );
    }

    @Override
    public void validate(String companyId, OFSErrors errors) throws Exception {
        for (InventoryCompanyValidation validation : VALIDATIONS) {
            validation.validate(companyId, errors);
        }

        if(!errors.isEmpty()) {
            throw new BadRequestException(errors);
        }
    }

    @Override
    public void validate(ChangeSet changeSet, String companyId, OFSErrors errors) throws Exception {
        for (InventoryCompanyValidation validation : VALIDATIONS) {
            validation.validate(changeSet, companyId, errors);
        }

        if(!errors.isEmpty()) {
            throw new BadRequestException(errors);
        }
    }
}
