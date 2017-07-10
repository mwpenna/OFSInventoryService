package com.ofs.validations.inventory;

import com.ofs.model.Inventory;
import com.ofs.server.errors.UnauthorizedException;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSErrors;
import com.ofs.server.security.SecurityContext;
import com.ofs.server.security.Subject;
import com.ofs.utils.StringUtils;
import com.ofs.validations.InventoryGetValidation;
import org.springframework.stereotype.Component;

@Component
public class ValidateInventoryAdminRole implements InventoryGetValidation {
    @Override
    public void validate(Inventory inventory, OFSErrors errors) throws Exception {
        Subject subject = SecurityContext.getSubject();

        if(subject.getRole().equalsIgnoreCase("ADMIN")) {
            if(!inventory.getCompanyId().equalsIgnoreCase(StringUtils.getIdFromURI(subject.getCompanyHref()))){
                throw new UnauthorizedException("OAuth", "OFSServer");
            }
        }
    }

    @Override
    public void validate(ChangeSet changeSet, Inventory inventory, OFSErrors errors) throws Exception {
        validate(inventory, errors);
    }
}
