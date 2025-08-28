import { createYoga } from "graphql-yoga"
import { NextRequest } from "next/server"
import { schema } from "../../../../graphql/schema"
import { prisma } from "../../../../lib/prisma"
import { auth } from "@/auth"


const yoga = createYoga<{ req: NextRequest }>({
   schema,
   graphqlEndpoint: "/api/graphql",
   context: async () => ({
      prisma,
      session: await auth(),
   }),
})

export { yoga as GET, yoga as POST }