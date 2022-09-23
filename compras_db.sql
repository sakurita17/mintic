-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema compras
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema compras
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `compras` DEFAULT CHARACTER SET utf8 ;
USE `compras` ;

-- -----------------------------------------------------
-- Table `compras`.`dependencia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `compras`.`dependencia` (
  `cod_dependencia` INT NOT NULL,
  `nombre_dependencia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`cod_dependencia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `compras`.`Usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `compras`.`Usuarios` (
  `cod_usuario` INT NOT NULL,
  `nombre_usuario` VARCHAR(45) NOT NULL,
  `mail_usuario` VARCHAR(45) NOT NULL,
  `telefono_usuario` VARCHAR(45) NOT NULL,
  `direccion_usuario` VARCHAR(45) NOT NULL,
  `cargo_usuario` VARCHAR(45) NOT NULL,
  `dependencia_cod_dependencia` INT NOT NULL,
  `Usuarioscol` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`cod_usuario`, `dependencia_cod_dependencia`),
  INDEX `fk_Usuarios_dependencia1_idx` (`dependencia_cod_dependencia` ASC) VISIBLE,
  CONSTRAINT `fk_Usuarios_dependencia1`
    FOREIGN KEY (`dependencia_cod_dependencia`)
    REFERENCES `compras`.`dependencia` (`cod_dependencia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `compras`.`Proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `compras`.`Proveedor` (
  `cod_prov` INT NOT NULL,
  `nombre_empresa` VARCHAR(45) NOT NULL,
  `rut_empresa` VARCHAR(45) NOT NULL,
  `mail_empresa` VARCHAR(45) NOT NULL,
  `direccion_empresa` VARCHAR(45) NOT NULL,
  `ciudad_empresa` VARCHAR(45) NOT NULL,
  `telefono_empresa` VARCHAR(45) NOT NULL,
  `cod_usuario` INT NOT NULL,
  PRIMARY KEY (`cod_prov`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `compras`.`estado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `compras`.`estado` (
  `cod_estado` INT NOT NULL,
  `nombre_estado` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`cod_estado`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `compras`.`Requisicion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `compras`.`Requisicion` (
  `cod_req` INT NOT NULL,
  `fecha_requisicion` DATE NOT NULL,
  `cantidad` VARCHAR(45) NOT NULL,
  `unidad` VARCHAR(45) NOT NULL,
  `producto` VARCHAR(45) NOT NULL,
  `aprobacion` VARCHAR(45) NOT NULL,
  `Usuarios_cod_usuario` INT NOT NULL,
  `estado_cod_estado` INT NOT NULL,
  PRIMARY KEY (`cod_req`, `Usuarios_cod_usuario`, `estado_cod_estado`),
  INDEX `fk_Requisicion_Usuarios_idx` (`Usuarios_cod_usuario` ASC) VISIBLE,
  INDEX `fk_Requisicion_estado1_idx` (`estado_cod_estado` ASC) VISIBLE,
  CONSTRAINT `fk_Requisicion_Usuarios`
    FOREIGN KEY (`Usuarios_cod_usuario`)
    REFERENCES `compras`.`Usuarios` (`cod_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Requisicion_estado1`
    FOREIGN KEY (`estado_cod_estado`)
    REFERENCES `compras`.`estado` (`cod_estado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `compras`.`Orden`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `compras`.`Orden` (
  `cod_orden` INT NOT NULL,
  `fecha_orden` DATETIME NOT NULL,
  `Usuarios_cod_usuario` INT NOT NULL,
  `Usuarios_dependencia_cod_dependencia` INT NOT NULL,
  PRIMARY KEY (`cod_orden`, `Usuarios_cod_usuario`, `Usuarios_dependencia_cod_dependencia`),
  INDEX `fk_Orden_Usuarios1_idx` (`Usuarios_cod_usuario` ASC, `Usuarios_dependencia_cod_dependencia` ASC) VISIBLE,
  CONSTRAINT `fk_Orden_Usuarios1`
    FOREIGN KEY (`Usuarios_cod_usuario` , `Usuarios_dependencia_cod_dependencia`)
    REFERENCES `compras`.`Usuarios` (`cod_usuario` , `dependencia_cod_dependencia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `compras`.`Cotizacion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `compras`.`Cotizacion` (
  `cod_cotizacion` INT NOT NULL,
  `producto` VARCHAR(45) NOT NULL,
  `cantida` INT NOT NULL,
  `valor_unitario` DOUBLE NOT NULL,
  `%IVA` DOUBLE NOT NULL,
  `subtotal` DOUBLE NOT NULL,
  `total` DOUBLE NOT NULL,
  `Requisicion_cod_req` INT NOT NULL,
  `Requisicion_Usuarios_cod_usuario` INT NOT NULL,
  `Requisicion_estado_cod_estado` INT NOT NULL,
  `Proveedor_cod_prov` INT NOT NULL,
  `Orden_cod_orden` INT NOT NULL,
  PRIMARY KEY (`cod_cotizacion`, `Requisicion_cod_req`, `Requisicion_Usuarios_cod_usuario`, `Requisicion_estado_cod_estado`, `Proveedor_cod_prov`, `Orden_cod_orden`),
  INDEX `fk_Cotizacion_Requisicion1_idx` (`Requisicion_cod_req` ASC, `Requisicion_Usuarios_cod_usuario` ASC, `Requisicion_estado_cod_estado` ASC) VISIBLE,
  INDEX `fk_Cotizacion_Proveedor1_idx` (`Proveedor_cod_prov` ASC) VISIBLE,
  INDEX `fk_Cotizacion_Orden1_idx` (`Orden_cod_orden` ASC) VISIBLE,
  CONSTRAINT `fk_Cotizacion_Requisicion1`
    FOREIGN KEY (`Requisicion_cod_req` , `Requisicion_Usuarios_cod_usuario` , `Requisicion_estado_cod_estado`)
    REFERENCES `compras`.`Requisicion` (`cod_req` , `Usuarios_cod_usuario` , `estado_cod_estado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cotizacion_Proveedor1`
    FOREIGN KEY (`Proveedor_cod_prov`)
    REFERENCES `compras`.`Proveedor` (`cod_prov`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cotizacion_Orden1`
    FOREIGN KEY (`Orden_cod_orden`)
    REFERENCES `compras`.`Orden` (`cod_orden`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `compras`.`Entregas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `compras`.`Entregas` (
  `cod_entrega` INT NOT NULL,
  `fecha_entrega` DATE NOT NULL,
  `cierre_entrega` VARCHAR(45) NOT NULL,
  `radicación_factura` VARCHAR(45) NOT NULL,
  `Orden_cod_orden` INT NOT NULL,
  `Orden_Usuarios_cod_usuario` INT NOT NULL,
  `Orden_Usuarios_dependencia_cod_dependencia` INT NOT NULL,
  PRIMARY KEY (`cod_entrega`, `Orden_cod_orden`, `Orden_Usuarios_cod_usuario`, `Orden_Usuarios_dependencia_cod_dependencia`),
  INDEX `fk_Entregas_Orden1_idx` (`Orden_cod_orden` ASC, `Orden_Usuarios_cod_usuario` ASC, `Orden_Usuarios_dependencia_cod_dependencia` ASC) VISIBLE,
  CONSTRAINT `fk_Entregas_Orden1`
    FOREIGN KEY (`Orden_cod_orden` , `Orden_Usuarios_cod_usuario` , `Orden_Usuarios_dependencia_cod_dependencia`)
    REFERENCES `compras`.`Orden` (`cod_orden` , `Usuarios_cod_usuario` , `Usuarios_dependencia_cod_dependencia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
