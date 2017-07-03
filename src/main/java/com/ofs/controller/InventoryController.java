package com.ofs.controller;

import com.ofs.model.Inventory;
import com.ofs.model.Template;
import com.ofs.repository.InventoryRepository;
import com.ofs.server.OFSController;
import com.ofs.server.OFSServerId;
import com.ofs.server.form.OFSServerForm;
import com.ofs.server.form.ValidationSchema;
import com.ofs.server.model.OFSErrors;
import com.ofs.server.security.Authenticate;
import com.ofs.server.security.SecurityContext;
import com.ofs.server.security.Subject;
import com.ofs.utils.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.net.URI;

@OFSController
@RequestMapping(value="/inventory", produces = MediaType.APPLICATION_JSON_VALUE)
@Slf4j
public class InventoryController {

    @Autowired
    private InventoryRepository inventoryRepository;

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    @ValidationSchema(value = "/inventory-create.json")
    @Authenticate
    @CrossOrigin(origins = "*")
    public ResponseEntity create(@OFSServerId URI id, OFSServerForm<Inventory> form) throws Exception{
        Inventory inventory = form.create(id);
        defaultValues(inventory);
        
        inventoryRepository.addInventory(inventory);
        return ResponseEntity.created(id).build();
    }

    private void defaultValues(Inventory inventory) {
        Subject subject = SecurityContext.getSubject();

        if(!subject.getRole().equalsIgnoreCase("SYSTEM_ADMIN") || inventory.getCompanyId()==null) {
            inventory.setCompanyId(StringUtils.getIdFromURI(subject.getCompanyHref()));
        }
    }
}
