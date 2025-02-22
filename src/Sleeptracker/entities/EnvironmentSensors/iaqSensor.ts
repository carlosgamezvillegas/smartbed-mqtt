import { IDeviceData } from '@ha/IDeviceData';
import { IMQTTConnection } from '@mqtt/IMQTTConnection';
import { JsonEnvironmentSensor } from './JsonEnvironmentSensor';

export class IaqSensor extends JsonEnvironmentSensor {
  constructor(mqtt: IMQTTConnection, deviceData: IDeviceData) {
    super(mqtt, deviceData, { description: 'IAQ Sensor' });
  }

  discoveryState() {
    return {
      ...super.discoveryState(),
      state_class: 'measurement',
      unit_of_measurement: 'ppm',
      device_class: 'carbon_dioxide',
      icon: 'mdi:molecule-co2',
    };
  }
}
