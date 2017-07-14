package com.ofs.validations.props;

import com.ofs.model.Props;
import com.ofs.server.form.update.ChangeSet;
import com.ofs.server.model.OFSError;
import com.ofs.server.model.OFSErrors;
import com.ofs.validators.Validator;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class ValidateDuplicateProps implements Validator<List<Props>>{

    @Override
    public void validate(List<Props> propsList, OFSErrors errors) throws Exception {
        propsList.forEach(prop -> {
            List inventoryList = propsList.stream().filter(inventoryProp ->  inventoryProp.getName().equalsIgnoreCase(prop.getName())).collect(Collectors.toList());

            if(inventoryList.size()>1) {
                OFSError error = errors.rejectValue("props.name.duplicate", "Invalid prop with name: {name}. Prop list contained multiple prop elements with the same name.");
                error.put("name" , prop.getName());
            }
        });
    }

    @Override
    public void validate(ChangeSet changeSet, List<Props> propsList, OFSErrors errors) throws Exception {
        validate(propsList, errors);
    }
}
