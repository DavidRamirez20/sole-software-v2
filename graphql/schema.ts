// /graphql/schema.ts
import { createSchema } from "graphql-yoga"
import { prisma } from "../lib/prisma"

   // === TYPEDEFS ===
   export const typeDefs = /* GraphQL */ `
   # =============================
   # ENUMS
   # =============================
   enum UserType {
      COORDINADOR
      COLABORADOR
   }

   enum EstadoRegistro {
      CONFIRMADO
      PENDIENTE
      CANCELADO
      PENDIENTE_POR_PROGRAMAR
      REPROGRAMADO
   }

   # =============================
   # MODELOS
   # =============================
   type User {
      id: ID!
      email: String!
      name: String!
      type: UserType!
      createdAt: String!
      updatedAt: String!
      coordinador: Coordinador
      colaborador: Colaborador
   }

   type Coordinador {
      id: ID!
      user: User!
   }

   type Colaborador {
      id: ID!
      identificacion: String!
      genero: String!
      celular: String!
      direccion: String!
      fechaNacimiento: String!
      eps: String!
      uniforme: Boolean!
      user: User!
      roles: [RolColaborador!]!
      registros: [Registro!]!
   }

   type RolColaborador {
      id: ID!
      name: String!
   }

   type Cliente {
      id: ID!
      nombre: String!
      empresas: [Empresa!]!
      programas: [Programa!]!
   }

   type Empresa {
      id: ID!
      nombre: String!
      cliente: Cliente!
      programas: [Programa!]!
   }

   type Programa {
      id: ID!
      nombre: String!
      sede: String!
      lugarLlegada: String!
      puntoEncuentro: String!
      actividad: String!
      direccion: String!
      personaContacto: String!
      modalidad: String!
      cliente: Cliente!
      empresa: Empresa!
      registros: [Registro!]!
      seguimientos: [Seguimiento!]!
   }

   type Registro {
      id: ID!
      numeroOrden: String!
      estado: EstadoRegistro!
      fechaServicio: String!
      horaInicio: String!
      horaFin: String!
      horasServicio: Int!
      colaborador: Colaborador!
      programa: Programa!
      cliente: Cliente!
      seguimientos: [Seguimiento!]!
      adicionales: String
      observaciones: String
   }

   type Seguimiento {
      id: ID!
      contenido: String!
      createdAt: String!
      programa: Programa!
      registro: Registro!
   }

   # =============================
   # QUERIES
   # =============================
   type Query {
      me: User
      users: [User!]!
      clientes: [Cliente!]!
      programas: [Programa!]!
      registros: [Registro!]!
      colaborador(id: ID!): Colaborador
   }

   # =============================
   # INPUTS Y MUTATIONS
   # =============================
   input CreateClienteInput {
      nombre: String!
   }

   input CreateProgramaInput {
      nombre: String!
      clienteId: Int!
      empresaId: Int!
      sede: String!
      lugarLlegada: String!
      puntoEncuentro: String!
      actividad: String!
      direccion: String!
      personaContacto: String!
      modalidad: String!
   }

   type Mutation {
      createCliente(data: CreateClienteInput!): Cliente!
      createPrograma(data: CreateProgramaInput!): Programa!
   }
   `

   // === RESOLVERS ===
   export function createResolvers() {
   return {
      Query: {
         me: async (_: any, __: any, ctx: any) => ctx.session?.user ?? null,
         users: () => prisma.user.findMany(),
         clientes: () => prisma.cliente.findMany(),
         programas: () => prisma.programa.findMany(),
         registros: () => prisma.registro.findMany(),
         colaborador: (_: any, { id }: any) =>
         prisma.colaborador.findUnique({
            where: { id: Number(id) },
         }),
      },
      Mutation: {
         createCliente: async (_: any, { data }: any) => {
         return prisma.cliente.create({ data })
         },
         createPrograma: async (_: any, { data }: any) => {
         return prisma.programa.create({ data })
         },
      },
      // Relaciones explícitas (cuando Prisma no resuelve automáticamente)
      Colaborador: {
         user: (parent: any) =>
         prisma.user.findUnique({ where: { id: parent.userId } }),
         roles: (parent: any) =>
         prisma.rolColaborador.findMany({
            where: { colaboradores: { some: { colaboradorId: parent.id } } },
         }),
         registros: (parent: any) =>
         prisma.registro.findMany({ where: { colaboradorId: parent.id } }),
      },
      Coordinador: {
         user: (parent: any) =>
         prisma.user.findUnique({ where: { id: parent.userId } }),
      },
      Empresa: {
         cliente: (parent: any) =>
         prisma.cliente.findUnique({ where: { id: parent.clienteId } }),
      },
      Programa: {
         cliente: (parent: any) =>
         prisma.cliente.findUnique({ where: { id: parent.clienteId } }),
         empresa: (parent: any) =>
         prisma.empresa.findUnique({ where: { id: parent.empresaId } }),
         registros: (parent: any) =>
         prisma.registro.findMany({ where: { programaId: parent.id } }),
         seguimientos: (parent: any) =>
         prisma.seguimiento.findMany({ where: { programaId: parent.id } }),
      },
      Registro: {
         colaborador: (parent: any) =>
         prisma.colaborador.findUnique({ where: { id: parent.colaboradorId } }),
         programa: (parent: any) =>
         prisma.programa.findUnique({ where: { id: parent.programaId } }),
         cliente: (parent: any) =>
         prisma.cliente.findUnique({ where: { id: parent.clienteId } }),
         seguimientos: (parent: any) =>
         prisma.seguimiento.findMany({ where: { registroId: parent.id } }),
      },
      Seguimiento: {
         programa: (parent: any) =>
         prisma.programa.findUnique({ where: { id: parent.programaId } }),
         registro: (parent: any) =>
         prisma.registro.findUnique({ where: { id: parent.registroId } }),
      },
   }
   }

   // === SCHEMA EXPORT ===
   export const schema = createSchema({
      typeDefs,
      resolvers: createResolvers(),
   })
