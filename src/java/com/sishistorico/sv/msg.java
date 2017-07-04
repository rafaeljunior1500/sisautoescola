/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.sishistorico.sv;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Queue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.AsyncContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Lamara
 */
@WebServlet(name = "msg", urlPatterns = {"/msg"},asyncSupported = true)
public class msg extends HttpServlet {

    	private Queue<AsyncContext> clients = new ConcurrentLinkedQueue<AsyncContext>();
	private BlockingQueue<String> messages = new LinkedBlockingQueue<String>();
	private AtomicInteger contador = new AtomicInteger();
	private AtomicInteger clientes = new AtomicInteger();

	@Override
	public void init() throws ServletException {
		final ExecutorService executors = Executors.newCachedThreadPool();
		Executors.newSingleThreadExecutor().execute(new Runnable() {
			public void run() {
				while (true) {
					try {
						final String message = messages.take();

						for (final AsyncContext ctx : clients) {
							executors.execute(new Runnable() {
								public void run() {
									try {
										PrintWriter writer = ctx.getResponse()
												.getWriter();
										writer.println(message);
										writer.flush();
									} catch (IOException e) {
										e.printStackTrace();
									}
								}

							});
						}
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
			}

		});
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse arg1)
			throws ServletException, IOException {
                    		AsyncContext ctx = req.startAsync();

		ctx.setTimeout(3000000);
		clients.add(ctx);
		System.out.println("novo cliente. id: " + clientes.incrementAndGet());
                
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse arg1)
			throws ServletException, IOException {
		System.out.println("enviando mensagem para   " + clientes + " clientes");
		messages.add(String.format("mensagem número %d %n", contador.incrementAndGet()));
               
                
	}

}
