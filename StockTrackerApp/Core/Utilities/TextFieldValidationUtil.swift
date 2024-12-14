//
//  TextFieldValidationUtil.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 03.12.2024..
//

struct TextFieldValidationUtil {
    static func getError(for field: ValidatedField, validationTriggered: Bool) -> String? {
        return (field.value.getNilOrTrimmed() != nil || validationTriggered) ? field.error : nil
    }
}
