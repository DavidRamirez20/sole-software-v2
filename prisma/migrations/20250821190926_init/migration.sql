-- CreateEnum
CREATE TYPE "public"."UserType" AS ENUM ('COORDINADOR', 'COLABORADOR');

-- CreateEnum
CREATE TYPE "public"."EstadoRegistro" AS ENUM ('CONFIRMADO', 'PENDIENTE', 'CANCELADO', 'PENDIENTE_POR_PROGRAMAR', 'REPROGRAMADO');

-- CreateTable
CREATE TABLE "public"."User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "public"."UserType" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Coordinador" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "Coordinador_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Colaborador" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "identificacion" TEXT NOT NULL,
    "genero" TEXT NOT NULL,
    "celular" TEXT NOT NULL,
    "direccion" TEXT NOT NULL,
    "fechaNacimiento" TIMESTAMP(3) NOT NULL,
    "eps" TEXT NOT NULL,
    "uniforme" BOOLEAN NOT NULL,

    CONSTRAINT "Colaborador_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ColaboradorRol" (
    "colaboradorId" INTEGER NOT NULL,
    "rolId" INTEGER NOT NULL,

    CONSTRAINT "ColaboradorRol_pkey" PRIMARY KEY ("colaboradorId","rolId")
);

-- CreateTable
CREATE TABLE "public"."RolColaborador" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "RolColaborador_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Cliente" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,

    CONSTRAINT "Cliente_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Empresa" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "clienteId" INTEGER NOT NULL,

    CONSTRAINT "Empresa_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Programa" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "empresaId" INTEGER NOT NULL,
    "clienteId" INTEGER NOT NULL,
    "sede" TEXT NOT NULL,
    "lugarLlegada" TEXT NOT NULL,
    "puntoEncuentro" TEXT NOT NULL,
    "actividad" TEXT NOT NULL,
    "direccion" TEXT NOT NULL,
    "personaContacto" TEXT NOT NULL,
    "modalidad" TEXT NOT NULL,

    CONSTRAINT "Programa_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Registro" (
    "id" SERIAL NOT NULL,
    "numeroOrden" TEXT NOT NULL,
    "estado" "public"."EstadoRegistro" NOT NULL,
    "fechaServicio" TIMESTAMP(3) NOT NULL,
    "horaInicio" TIMESTAMP(3) NOT NULL,
    "horaFin" TIMESTAMP(3) NOT NULL,
    "horasServicio" INTEGER NOT NULL,
    "colaboradorId" INTEGER NOT NULL,
    "programaId" INTEGER NOT NULL,
    "clienteId" INTEGER NOT NULL,
    "adicionales" TEXT,
    "observaciones" TEXT,

    CONSTRAINT "Registro_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Seguimiento" (
    "id" SERIAL NOT NULL,
    "programaId" INTEGER NOT NULL,
    "registroId" INTEGER NOT NULL,
    "contenido" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Seguimiento_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Coordinador_userId_key" ON "public"."Coordinador"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Colaborador_userId_key" ON "public"."Colaborador"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Colaborador_identificacion_key" ON "public"."Colaborador"("identificacion");

-- CreateIndex
CREATE UNIQUE INDEX "RolColaborador_name_key" ON "public"."RolColaborador"("name");

-- AddForeignKey
ALTER TABLE "public"."Coordinador" ADD CONSTRAINT "Coordinador_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Colaborador" ADD CONSTRAINT "Colaborador_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ColaboradorRol" ADD CONSTRAINT "ColaboradorRol_colaboradorId_fkey" FOREIGN KEY ("colaboradorId") REFERENCES "public"."Colaborador"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ColaboradorRol" ADD CONSTRAINT "ColaboradorRol_rolId_fkey" FOREIGN KEY ("rolId") REFERENCES "public"."RolColaborador"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Empresa" ADD CONSTRAINT "Empresa_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "public"."Cliente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Programa" ADD CONSTRAINT "Programa_empresaId_fkey" FOREIGN KEY ("empresaId") REFERENCES "public"."Empresa"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Programa" ADD CONSTRAINT "Programa_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "public"."Cliente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Registro" ADD CONSTRAINT "Registro_colaboradorId_fkey" FOREIGN KEY ("colaboradorId") REFERENCES "public"."Colaborador"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Registro" ADD CONSTRAINT "Registro_programaId_fkey" FOREIGN KEY ("programaId") REFERENCES "public"."Programa"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Registro" ADD CONSTRAINT "Registro_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "public"."Cliente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Seguimiento" ADD CONSTRAINT "Seguimiento_programaId_fkey" FOREIGN KEY ("programaId") REFERENCES "public"."Programa"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Seguimiento" ADD CONSTRAINT "Seguimiento_registroId_fkey" FOREIGN KEY ("registroId") REFERENCES "public"."Registro"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
