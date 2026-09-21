public class VehicleOrderTriggerHandler {

    public static void handleTrigger(
        List<Vehicle_Order__c> newOrders,
        Map<Id, Vehicle_Order__c> oldOrders,
        Boolean isBefore,
        Boolean isAfter,
        Boolean isInsert,
        Boolean isUpdate
    ) {

        // Before Insert / Update
        if (isBefore && (isInsert || isUpdate)) {
            preventOrderIfOutOfStock(newOrders, oldOrders, isUpdate);
        }

        // After Insert / Update
        if (isAfter && (isInsert || isUpdate)) {
            updateStockOnOrderConfirmation(newOrders, oldOrders, isUpdate);
        }
    }

    // Prevent confirmation when vehicle is out of stock
    private static void preventOrderIfOutOfStock(
        List<Vehicle_Order__c> orders,
        Map<Id, Vehicle_Order__c> oldOrders,
        Boolean isUpdate
    ) {

        Set<Id> vehicleIds = new Set<Id>();

        for (Vehicle_Order__c order : orders) {

            // Check only when the order is being confirmed
            Boolean isBeingConfirmed =
                order.Status__c == 'Confirmed' &&
                (
                    !isUpdate ||
                    oldOrders.get(order.Id).Status__c != 'Confirmed'
                );

            if (isBeingConfirmed && order.Vehicle__c != null) {
                vehicleIds.add(order.Vehicle__c);
            }
        }

        if (vehicleIds.isEmpty()) {
            return;
        }

        Map<Id, Vehicle__c> vehicleMap = new Map<Id, Vehicle__c>(
            [SELECT Id, Stock_Quantity__c
FROM Vehicle__c
                WHERE Id IN :vehicleIds
            ]
        );

        for (Vehicle_Order__c order : orders) {

            if (order.Vehicle__c == null ||
                !vehicleMap.containsKey(order.Vehicle__c)) {
                continue;
            }

            Boolean isBeingConfirmed =
                order.Status__c == 'Confirmed' &&
                (
                    !isUpdate ||
                    oldOrders.get(order.Id).Status__c != 'Confirmed'
                );

            if (isBeingConfirmed) {

                Vehicle__c vehicle = vehicleMap.get(order.Vehicle__c);

                if (vehicle.Stock_Quantity__c == null ||
                    vehicle.Stock_Quantity__c <= 0) {

                    order.addError(
                        'This vehicle is out of stock. Order cannot be confirmed.'
                    );
                }
            }
        }
    }

    // Reduce stock when an order becomes Confirmed
    private static void updateStockOnOrderConfirmation(
        List<Vehicle_Order__c> orders,
        Map<Id, Vehicle_Order__c> oldOrders,
        Boolean isUpdate
    ) {

        Set<Id> vehicleIds = new Set<Id>();

        for (Vehicle_Order__c order : orders) {

            Boolean isNewlyConfirmed =
                order.Status__c == 'Confirmed' &&
                (
                    !isUpdate ||
                    oldOrders.get(order.Id).Status__c != 'Confirmed'
                );

            if (isNewlyConfirmed && order.Vehicle__c != null) {
                vehicleIds.add(order.Vehicle__c);
            }
        }

        if (vehicleIds.isEmpty()) {
            return;
        }

        Map<Id, Vehicle__c> vehicleMap = new Map<Id, Vehicle__c>(
            [
                SELECT Id, Stock_Quantity__c
                FROM Vehicle__c
                WHERE Id IN :vehicleIds
            ]
        );

        List<Vehicle__c> vehiclesToUpdate = new List<Vehicle__c>();

        for (Vehicle_Order__c order : orders) {

            Boolean isNewlyConfirmed =
                order.Status__c == 'Confirmed' &&
                (
                    !isUpdate ||
                    oldOrders.get(order.Id).Status__c != 'Confirmed'
                );

            if (isNewlyConfirmed &&
                vehicleMap.containsKey(order.Vehicle__c)) {

                Vehicle__c vehicle = vehicleMap.get(order.Vehicle__c);

                if (vehicle.Stock_Quantity__c != null &&
                    vehicle.Stock_Quantity__c > 0) {

                    vehicle.Stock_Quantity__c -= 1;
                    vehiclesToUpdate.add(vehicle);
                }
            }
        }

        if (!vehiclesToUpdate.isEmpty()) {
            update vehiclesToUpdate;
        }
    }
}