package com.ofs.validations.inventory;

import com.ofs.model.Inventory;
import com.ofs.server.errors.UnauthorizedException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.server.security.SecurityContext;
import com.ofs.server.security.Subject;
import com.ofs.utils.StringUtils;
import com.ofs.validations.InventoryGetValidation;
import com.ofs.validations.InventoryUpdateValidation;
import org.springframework.stereotype.Component;

@Component
public class ValidateInventoryAccountManagerRole implements InventoryGetValidation, InventoryUpdateValidation {
    @Override
    public void validate(Inventory inventory, OFSErrors errors) throws Exception {
        Subject subject = SecurityContext.getSubject();

        if(subject.getRole().equals("ACCOUNT_MANAGER")) {
            if(!StringUtils.getIdFromURI(subject.getCompanyHref()).equals(inventory.getCompanyId())) {
                throw new UnauthorizedException("OAuth", "OFSServer");
            }
        }
    }

    @Override
    public void validate(ChangeSet changeSet, Inventory inventory, OFSErrors errors) throws Exception {
        validate(inventory, errors);
    }
}
