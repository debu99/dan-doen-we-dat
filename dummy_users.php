<?php

$string = file_get_contents("/home/michael/test.json");
$json_a = json_decode($string, true);

function insertUser($user){
    $db = Engine_Db_Table::getDefaultAdapter();
    $lastUserId = $db->query('SELECT * FROM dandoe_se5.engine4_users ORDER BY `user_id` DESC LIMIT 1')->fetchAll()[0]['user_id'];

    $sqlQuery = <<<EOD
    INSERT INTO `dandoe_se5`.`engine4_users` 
    (`user_id`,`email`, `displayname`, `photo_id`, `password`, `salt`, `locale`, `language`, `timezone`, `search`, `show_profileviewers`, 
     `level_id`, `invites_used`, `extra_invites`, `enabled`, `verified`, `approved`, `creation_date`, `creation_ip`, `modified_date`, `lastlogin_date`, 
     `lastlogin_ip`, `member_count`, `view_count`, `comment_count`, `like_count`, `coverphoto`, `view_privacy`, `disable_email`, `disable_adminemail`, 
     `login_attempt_count`, `lastLoginDate`, `lastUpdateDate`, `inviteeName`, `profileType`, `memberLevel`, `profileViews`, `joinedDate`, `friendsCount`, `is_dummy_user`
    ) 
    VALUES ('{$lastUserId}', '{$user["email"]}', '{$user["displayName"]}', '0', '$2y$10$Sfa0sWgt40bMsYsa78cWtOht5zJWJLYyVKn8WFHfbcqS.LYkYIZm2', '1925740', 'en', 'en', 'Europe/Berlin', 
            '1', '1', '4', '0', '0', '1', '0', '1', '2020-08-11 21:07:48', ?, '2020-08-11 21:11:11', '2020-08-11 21:18:43', ?, '0', '0', '0', '0', '0', 'everyone', 
            '0', '0', '0', 'everyone', 'everyone', 'everyone', 'everyone', 'everyone', 'everyone', 'everyone', 'everyone', '1')
    EOD;
    $db->query($sqlQuery);
}

function insertProfile($user, $user_id){
    $db = Engine_Db_Table::getDefaultAdapter();
    $genderCode = $user[`gender`] == 'male'? 2:1;
    $db->query("INSERT INTO `dandoe_se5`.`engine4_user_fields_values` (`item_id`, `field_id`, `index`, `value`) VALUES ('{$user_id}', '3', '0', '{$user[`firstname`]}'");
    $db->query("INSERT INTO `dandoe_se5`.`engine4_user_fields_values` (`item_id`, `field_id`, `index`, `value`) VALUES ('{$user_id}', '4', '0', '{$user[`lastname`]}'");
    $db->query("INSERT INTO `dandoe_se5`.`engine4_user_fields_values` (`item_id`, `field_id`, `index`, `value`) VALUES ('{$user_id}', '5', '0', '{$genderCode}'");
    $db->query("INSERT INTO `dandoe_se5`.`engine4_user_fields_values` (`item_id`, `field_id`, `index`, `value`) VALUES ('{$user_id}', '6', '0', '{$user[`birthDay`]}'");
    $db->query("INSERT INTO `dandoe_se5`.`engine4_user_fields_values` (`item_id`, `field_id`, `index`, `value`) VALUES ('{$user_id}', '12', '0', '{$user[`about`]}'");
    $db->query("INSERT INTO `dandoe_se5`.`engine4_user_fields_values` (`item_id`, `field_id`, `index`, `value`) VALUES ('{$user_id}', '14', '0', '{$user[`lastTimeTried`]}'");
    $db->query("INSERT INTO `dandoe_se5`.`engine4_user_fields_values` (`item_id`, `field_id`, `index`, `value`) VALUES ('{$user_id}', '15', '0', '{$user[`likeToLearn`]}'");
    $db->query("INSERT INTO `dandoe_se5`.`engine4_user_fields_values` (`item_id`, `field_id`, `index`, `value`) VALUES ('{$user_id}', '17', '0', '{$user[`city`]}'");
    $db->query("INSERT INTO `dandoe_se5`.`engine4_user_fields_values` (`item_id`, `field_id`, `index`, `value`) VALUES ('{$user_id}', '18', '0', '{$user[`degree`]}'");
    $db->query("INSERT INTO `dandoe_se5`.`engine4_user_fields_values` (`item_id`, `field_id`, `index`, `value`) VALUES ('{$user_id}', '19', '0', '{$user[`profession`]}'");
}

function insertImages($user, $user_id) {
    $db = Engine_Db_Table::getDefaultAdapter();
    $last_file_id = $db->query('SELECT file_id FROM dandoe_se5.engine4_storage_files ORDER BY `user_id` DESC LIMIT 1;')->fetchAll()[0]['file_id'];
    $db->query('SELECT file_id FROM dandoe_se5.engine4_storage_files ORDER BY `user_id` DESC LIMIT 1;');


    $db->query(<<<EOD
        INSERT INTO `dandoe_se5`.`engine4_storage_files` 
            (`file_id`, `parent_file_id`, `type`, `parent_type`, `parent_id`, `user_id`, `creation_date`, `modified_date`, `service_id`, 
            `storage_path`, `extension`, `name`, `mime_major`, `mime_minor`, `size`, `hash`
            ) 
        VALUES 
            (NULL, NULL, NULL, 'user', `{$user_id}`, `{$user_id}`, '2020-08-11 21:07:18', '2020-08-11 21:07:18', '1', 
            'public/seeded-users/{'{$user['pictures']['large']}/{$user["hash"]}.jpg', 'jpg', '{$user['hash']}.jpg', 
            'image', 'jpeg', '16187', ''{$user['hash']}'
        )
        EOD
    );
    $last_file_id_next = $last_file_id + 1;

    $db->query(<<<EOD
        INSERT INTO `dandoe_se5`.`engine4_storage_files` 
            (`file_id`, `parent_file_id`, `type`, `parent_type`, `parent_id`, `user_id`, `creation_date`, `modified_date`, `service_id`, 
             `storage_path`, `extension`, `name`, `mime_major`, `mime_minor`, `size`, `hash`
            ) 
        VALUES 
            (`{$last_file_id_next}`, `{$last_file_id}`, 'thumb.profile', 'user', `{$user_id}`, `{$user_id}`, '2020-08-11 21:07:18', '2020-08-11 21:07:18', '1', 
             'public/seeded-users/{$user['pictures']['large']}/{$user["hash"]}.jpg', 'jpg', '{$user['hash']}.jpg', 
             'image', 'jpeg', '16187', ''{$user['hash']}'
        )
        EOD
    );

    $last_file_id_next = $last_file_id_next + 1;

    $db->query(<<<EOD
        INSERT INTO `dandoe_se5`.`engine4_storage_files` 
            (`file_id`, `parent_file_id`, `type`, `parent_type`, `parent_id`, `user_id`, `creation_date`, `modified_date`, `service_id`, 
             `storage_path`, `extension`, `name`, `mime_major`, `mime_minor`, `size`, `hash`
            ) 
        VALUES 
            (`{$last_file_id_next}`, `{$last_file_id}`, 'thumb.profile', 'user', `{$user_id}`, `{$user_id}`, '2020-08-11 21:07:18', '2020-08-11 21:07:18', '1', 
             'public/seeded-users/{$user['pictures']['medium']}/{$user["hash"]}.jpg', 'jpg', '{$user['hash']}.jpg', 
             'image', 'jpeg', '16187', ''{$user['hash']}'
        )
        EOD
    );

    $last_file_id_next = $last_file_id_next + 1;

    $db->query(<<<EOD
        INSERT INTO `dandoe_se5`.`engine4_storage_files` 
            (`file_id`, `parent_file_id`, `type`, `parent_type`, `parent_id`, `user_id`, `creation_date`, `modified_date`, `service_id`, 
             `storage_path`, `extension`, `name`, `mime_major`, `mime_minor`, `size`, `hash`
            ) 
        VALUES 
            (`{$last_file_id_next}`, `{$last_file_id}`, 'thumb.icon', 'user', `{$user_id}`, `{$user_id}`, '2020-08-11 21:07:18', '2020-08-11 21:07:18', '1', 
             'public/seeded-users/{$user['pictures']['thumbnail']}/{$user["hash"]}.jpg', 'jpg', '{$user['hash']}.jpg', 
             'image', 'jpeg', '16187', ''{$user['hash']}'
        )
        EOD
    );

    return $last_file_id;
}

function updateUserWithFileId($user_id, $file_id){
    $db = Engine_Db_Table::getDefaultAdapter();
    $db->query("UPDATE `dandoe_se5`.`engine4_storage_files` SET `file_id` = '{$file_id}', `parent_file_id` = '992', `parent_id` = '17', `user_id` = '17' WHERE (`user_id` = '{$user_id}')");
}


function removeDummyUsers(){
    $db = Engine_Db_Table::getDefaultAdapter();
    $dummyUsers = $db->query('SELECT * FROM dandoe_se5.engine4_users WHERE (`is_dummy_user` = `1`)')->fetchAll();

    $userIds = array_map(function($user){
        return $user["user_id"];
    }, $dummyUsers);

    $db->query("DELETE FROM `dandoe_se5`.`engine4_user_fields_values` WHERE `item_id` IN ('`.$userIds.`')'");
    $db->query("DELETE FROM `dandoe_se5`.`engine4_storage_files` WHERE `parent_id` IN ('`.$userIds.`')");
    $db->query("DELETE FROM `dandoe_se5`.`engine4_users` WHERE `user_id` IN ('`.$userIds.`')");
}